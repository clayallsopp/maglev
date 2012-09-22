module Maglev
  module Hashable
    def initialize(properties = {})
      update_attributes(properties)
    end

    def update_attributes(properties = {})
      attributes = self.methods - Object.methods
      used_attributes = []
      properties.each do |key, value|
        used_attributes << key
        if attributes.member?("#{key}=:".to_sym)
          self.send("#{key}=:".to_sym, value)
        end
      end

      self.class.remote_attributes.each do |name, options|
        if options[:json_path]
          self.send("#{name}=", properties.valueForKeyPath(options[:json_path]))
        end
      end
    end
  end
end