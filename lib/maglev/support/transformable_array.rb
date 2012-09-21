module Maglev
  module Support
    class TransformableArray < Array
      attr_accessor :transform
      def <<(value)
        if self.transform
          value = self.transform.call(value)
        end
        super(value)
      end
    end
  end
end