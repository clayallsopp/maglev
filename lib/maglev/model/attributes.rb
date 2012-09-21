module Maglev
  module Attributes
    # Arguments will:
    # - be normal ruby attributes
    def remote_attributes(*args)
      @remote_attributes ||= []
      args.each do |arg|
        remote_attribute(arg)
      end
      @remote_attributes
    end

    # EX
    #   remote_attribute :name
    # EX
    #   remote_attribute :name, json_path: "username"
    # EX
    #   remote_attribute :name do |json|
    #     self.name = json["first_name"] + json["last_name"]
    #   end
    def remote_attribute(name, options = {})
      @remote_attributes ||= []
      attr_accessor name
      @remote_attributes << { (options[:json_path] || name.to_sym) => name }
      @remote_attributes
    end
  end
end