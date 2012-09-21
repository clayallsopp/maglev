module Maglev
  module ModelUrls
    def collection_path(path = nil)
      @collection_path = Maglev::Support::FormatableString.new(path) if path

      @collection_path
    end

    def member_path(path = nil)
      @member_path = Maglev::Support::FormatableString.new(path) if path

      @member_path
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