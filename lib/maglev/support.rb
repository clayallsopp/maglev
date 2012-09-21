module Maglev
  module Support
    module_function

    def classify_string(klass)
      klass.to_s.split("_").collect {|s| s.capitalize}.join
    end

    def get_or_make_class(klass_str, superklass = Maglev::Model)
      if Module.const_defined? klass_str
        begin
          Object.const_get(klass_str)
        rescue NameError => e
          make_class(klass_str, superklass)
        end
      else
        make_class(klass_str, superklass)
      end
    end

    def make_class(klass_str, superklass)
      Object.const_set(klass_str, Class.new(superklass))
    end
  end
end