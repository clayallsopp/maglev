module Maglev
  module ModelUrls
    def collection_path(path = nil, options = {})
      if path
        @collection_path = { path: Maglev::Support::FormatableString.new(path), options: options }
      end

      @collection_path[:path]
    end

    def collection_options
      @collection_path[:options]
    end

    def member_path(path = nil, options = {})
      if path
        @member_path = { path: Maglev::Support::FormatableString.new(path), options: options }
      end

      @member_path[:path]
    end

    def member_options
      @member_path[:options]
    end

    def custom_paths(options = {})
      @custom_paths ||= {}
      options.each do |path_name, path_format|
        @custom_paths[path_name] = Maglev::Support::FormatableString.new(path_format)

        define_singleton_method path_name, ->(*args) do
          @custom_paths[path_name].format(args && args[0], self)
        end

        define_method path_name, ->(*args) do
          self.class.custom_paths[path_name].format(args && args[0], self)
        end
      end
      @custom_paths
    end
  end

  module ModelUrlsInstance
    def collection_path(params = {})
      self.class.collection_path.format(params, self)
    end

    def member_path(params = {})
      self.class.member_path.format(params, self)
    end
  end
end