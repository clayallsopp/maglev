module Maglev
  module Support
    module TransformHash
      module_function

      def transform(value, klass)
        transformed = value
        if transformed.is_a? Hash
          transformed = klass.new(value)
        elsif not value.is_a? klass
          raise Maglev::Error::InvalidClassError, "#{value.inspect} is not a Hash or #{klass.inspect}"
        end
        transformed
      end
    end
  end
end