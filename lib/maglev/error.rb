module Maglev
  module Error
    class InvalidClassError < StandardError; end
    class BlockArgumentsError < StandardError; end
    class BlockRequiredError < StandardError; end
  end
end