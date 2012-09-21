module Maglev
  module Support
    # Any methods sent to it will be added as members of the hash
    class DslWriter
      attr_accessor :hash
      def initialize
        @hash = {}
      end

      def method_missing(method, *args, &block)
        @hash[method.to_s] = args[0]
      end
    end
  end
end