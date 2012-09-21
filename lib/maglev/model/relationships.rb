module Maglev
  module Relationships
    # OPTIONS
    # - class_name
    # - through_path
    # - json_path
    def remote_has_one(name = nil, options = {})
      @remote_has_one ||= {}

      if name && name = name.to_s
        class_name = options[:class_name] || Maglev::Support.classify_string(name)
        klass = Maglev::Support.get_or_make_class(class_name)
        through_path = options[:through_path] || "/#{name}"
        json_path = options[:json_path] || name

        ivar = "@#{name}"
        attr_reader name

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

        @remote_has_one[name] = {
          class: klass,
          through_path: through_path,
          json_path: json_path
        }
      end

      @remote_has_one
    end

    def remote_has_one?(klass)
      has = false
      self.remote_has_one.each do |name, hash|
        has = true if hash[:class] == klass
      end
      has
    end

    def remote_belongs_to(name = nil, options = {})
      @remote_belongs_to ||= {}

      if name && name = name.to_s
        class_name = options[:class_name] || Maglev::Support.classify_string(name)
        klass = Maglev::Support.get_or_make_class(class_name)
        through_path = options[:through_path] || "/#{name}"
        json_path = options[:json_path] || name

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

        @remote_belongs_to[name] = {
          class: klass,
          through_path: through_path,
          json_path: json_path
        }
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
        class_name = options[:class_name] || Maglev::Support.classify_string(name.singularize)
        klass = Maglev::Support.get_or_make_class(class_name)
        through_path = options[:through_path] || "/#{name}"
        json_path = options[:json_path] || name

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

        @remote_has_many[name] = {
          class: klass,
          through_path: through_path,
          json_path: json_path
        }
      end

      @remote_has_many
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