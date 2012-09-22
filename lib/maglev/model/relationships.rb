module Maglev
  module Relationships
    # OPTIONS
    # - class_name
    # - json_path
    # - collection_path
    # - member_path
    def remote_has_one(name = nil, options = {})
      @remote_has_one ||= {}

      if name && name = name.to_s
        klass, _collection_path, _member_path = build_relationship("@remote_has_one", name, options)

        # GETTER
        ivar = "@#{name}"
        attr_reader name

        # SETTER
        define_method("#{name}=") do |value|
          model_value = Maglev::Support::TransformHash.transform(value, klass)
  
          # EX
          # user.feed = a_feed
          # then we set feed.user = user
          if model_value.class.remote_belongs_to? self.class and !blocked?
            model_value.block_in do
              model_value.send("#{self.class.snake_case}=", self)
            end
          end

          instance_variable_set(ivar, model_value)
        end
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
        klass, _collection_path, _member_path = build_relationship("@remote_belongs_to", name, options)

        ivar = "@#{name}"
        attr_reader name

        # EX
        # feed.user = a_user
        # then we set
        # user.feed = feed
        define_method("#{name}=") do |value|
          model_value = Maglev::Support::TransformHash.transform(value, klass)

          if model_value.class.remote_has_one? self.class and !blocked?
            model_value.block_in do
              model_value.send("#{self.class.snake_case}=", self)
            end
          end

          instance_variable_set(ivar, model_value)
        end
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
          instance_variable_get(ivar)
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
    def build_relationship(ivar, name, options, singular = false)
      json_path = options[:json_path] || name

      class_name = options[:class_name] || Maglev::Support.classify_string(singular ? name.singularize : name)
      klass = Maglev::Support.get_or_make_class(class_name)
      _collection_path = options[:collection_path] || klass.collection_path
      _member_path = options[:member_path] || klass.member_path

      instance_variable_get(ivar)[name] = {
        class: klass,
        json_path: json_path,
        collection_path: _collection_path,
        member_path: _member_path
      }

      [klass, _collection_path, _member_path]
    end

    def add_dsl_extension_attr(name, klass, _collection_path, _member_path)
      alias_method "old_#{name}", name

      define_method("#{name}") do
        value = self.send("old_#{name}")
        self.class.send(:add_dsl_extension, value, klass, _collection_path, _member_path)
        value
      end
    end

    def add_dsl_extension(object, klass, _collection_path, _member_path)
      # Add some DSL finders to it
      # EX
      # user.feeds.find_all do |feeds|
      #   ...
      # end
      # Give it the HTTP methods
      object.send(:extend, Maglev::API::HTTP)
      # Defer http_call to the resource class
      def object.http_call(method, url, call_options = {}, &block)
        klass.http_call(method, url, call_options, &block)
      end
      # Give it the AR finders
      object.send(:extend, Maglev::Record)
      # Give it the _path helpers
      object.send(:extend, Maglev::ModelUrls)
      object.collection_path _collection_path
      object.member_path _member_path
      # use this resource Klass, not the object's class
      def object.create_model(json)
        klass.new(json)
      end
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