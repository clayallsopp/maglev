module Maglev
  module Hashable
    def initialize(properties = {})
      update_attributes(properties)
    end

    def update_attributes(properties = {})
      attributes = self.methods - Object.methods
      properties.each do |key, value|
        if attributes.member?("#{key}=:".to_sym)
          self.send("#{key}=:".to_sym, value)
        end
      end
    end
  end
end