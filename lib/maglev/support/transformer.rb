module Maglev
  module Support
    class Transformer
      # Maglev::Transformer.to(NSString) do |value, reversed|
      # end 
      def self.to(klass, params = {}, &transform_value)
        if !transform_value || ![1,2].member?(transform_value.arity)
          raise Maglev::Error::BlockRequiredError, "Need to include a block with one or two arguments for Maglev::Transformer.to"
        end
        ns_transformer = Maglev::Support.make_class("#{klass}Transformer#{transform_value.object_id}", NSValueTransformer)
        ns_transformer.define_singleton_method("transformedValueClass") do
          klass
        end

        reversable = transform_value.arity == 2
        ns_transformer.define_singleton_method("allowsReverseTransformation") do
          reversable
        end
        ns_transformer.send(:define_method, "transformedValue") do |value|
          if reversable
            transform_value.call(value, nil)
          else
            transform_value.call(value)
          end
        end
        if reversable
          ns_transformer.send(:define_method, "reverseTransformedValue") do |value|
            transform_value.call(nil, value)
          end
        end
        ns_transformer
      end
    end
  end
end