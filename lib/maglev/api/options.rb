module Maglev
  module API
    module Options
      DSL_PROPERTIES = [:root, :extension]
      def self.included(base)
        base.send(:attr_writer, :default_url_options)

        DSL_PROPERTIES.each do |prop|
          base.send(:attr_writer, prop)

          # allows us to use a nice DSL with ='s
          base.send(:define_method, "#{prop}", ->(value = -1) {
            self.send("#{prop}=", value) if value != -1

            instance_variable_get("@#{prop}")
          })
        end
      end

      def setup(&block)
        instance_eval &block
      end

      def default_url_options(value = -1, &block)
        return @default_url_options if value == -1 and block.nil?

        if block
          o = Maglev::Support::DslWriter.new
          o.instance_eval &block
          self.default_url_options = o.hash
        elsif value != -1
          self.default_url_options = value
        end

        self.default_url_options
      end

      def default_query=(value)
        self.default_url_options[:query] = value
      end

      def default_query(value = -1, &block)
        return self.default_url_options[:query] if value == -1 and block.nil?

        if block
          o = Maglev::Support::DslWriter.new
          o.instance_eval &block
          self.default_query = o.hash
        elsif value != -1
          self.default_query = value
        end

        self.default_url_options[:query]
      end

      def complete_url(fragment)
        return fragment if fragment[0..3] == "http"
          
        self.root + fragment + (self.extension || "")
      end
    end
  end
end