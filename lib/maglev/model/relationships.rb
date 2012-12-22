module Maglev
  module Relationships
    module Support
      module_function

      def attach_model_dsl(model_value, klass, _collection_path, _member_path, options, delegate)
        # Attach the DSL to the model
        # i.e. user.friends.remote_find_all do
        # end
        model_value.extend(Maglev::ModelUrls)
        model_value.collection_path(_collection_path, options)
        model_value.member_path(_member_path, options)
        model_value.extend(Maglev::API::HTTP)
        model_value.define_singleton_method "http_call", -> (method, url, call_options = {}, &block) {
          klass.http_call(method, url, call_options, &block)
        }
        model_value.extend(Maglev::Record)
        model_value.define_singleton_method "record_class" {
          klass
        }
        model_value.define_singleton_method "delegate" {
          delegate
        }
      end
    end
    # OPTIONS
    # - class_name
    # - json_path
    # - collection_path
    # - member_path
    def remote_has_one(name = nil, options = {})
      @remote_has_one ||= {}

      if name && name = name.to_s
        create_singular_methods(name, options, "remote_has_one")
      end

      @remote_has_one
    end

    def remote_has_one?(klass)
      self.remote_has_one.any? do |name, hash|
        hash[:class] == klass
      end
    end

    def remote_belongs_to(name = nil, options = {})
      @remote_belongs_to ||= {}

      if name && name = name.to_s
        create_singular_methods(name, options, "remote_belongs_to")
      end

      @remote_belongs_to
    end

    def remote_belongs_to?(klass)
      self.remote_belongs_to.any? do |name, hash|
        hash[:class] == klass
      end
    end

    def remote_has_many(name = nil, options = {})
      @remote_has_many ||= {}

      if name && name = name.to_s
        klass, _collection_path, _member_path = build_relationship("@remote_has_many", name, options, true)

        ivar = "@#{name}"
        define_method("#{name}") do
          if !instance_variable_defined? ivar
            arr = Maglev::Support::TransformableArray.new
            arr.transform = lambda { |value|
              model_value = Maglev::Support::TransformHash.transform(value, klass)

              # EX
              # user.feeds << a_feed
              # then we set feed.user = user
              if model_value.class.remote_belongs_to? self.class and !blocked?
                model_value.block_in do
                  model_value.send("#{self.class.snake_case}=", self)
                end
              end

              model_value
            }

            instance_variable_set(ivar, arr)
          end
          model_value = instance_variable_get(ivar)

          Maglev::Relationships::Support.attach_model_dsl(model_value, klass, _collection_path, _member_path, options, self)

          model_value
        end

        define_method("#{name}=") do |values|
          self.send("#{name}").clear
          values.each do |value|
            self.send("#{name}") << value
          end
          self.send("#{name}")
        end
      end

      @remote_has_many
    end

    private
    def create_singular_methods(name, options, method)
      klass, _collection_path, _member_path = build_relationship("@#{method}", name, options)

      ivar = "@#{name}"
      define_method("#{name}") do
        model_value = instance_variable_get(ivar)

        Maglev::Relationships::Support.attach_model_dsl(model_value, klass, _collection_path, _member_path, options, self)

        model_value
      end

      # EX
      # feed.user = a_user
      # then we set
      # user.feed = feed
      opposite_method = {"remote_belongs_to" => "remote_has_one", "remote_has_one" => "remote_belongs_to"}[method]
      define_method("#{name}=") do |value|
        model_value = Maglev::Support::TransformHash.transform(value, klass)

        if model_value.class.send("#{opposite_method}?", self.class) and !blocked?
          model_value.block_in do
            model_value.send("#{self.class.snake_case}=", self)
          end
        end

        instance_variable_set(ivar, model_value)
      end
    end

    def build_relationship(ivar, name, options, singular = false)
      # EX: 'friends' -> {}['friends']
      json_path = options[:json_path] || name

      # EX: 'friends' -> 'Friends', 'wall_post' -> 'WallPost'
      class_name = options[:class_name] || Maglev::Support.classify_string(singular ? name.singularize : name)
      klass = Maglev::Support.get_or_make_class(class_name)
      # If the klass already exists, the klass.collection_path will also exist. else nil.
      _collection_path = options[:collection_path] || klass.collection_path
      _member_path = options[:member_path] || klass.member_path

      # EX: '@remote_has_many['friends'] = {}...'
      # Applied to each model
      instance_variable_get(ivar)[name] = {
        class: klass,
        json_path: json_path,
        collection_path: _collection_path,
        member_path: _member_path
      }

      [klass, _collection_path, _member_path]
    end
  end

  module RelationshipsInstance
    # Used as a semaphore-esque structure.
    def block_in(&block)
      block_updates
      block.call
      unblock_updates
    end

    private
    def block_updates
      @block = true
    end

    def unblock_updates
      @block = false
    end

    def blocked?
      @block
    end
  end
end