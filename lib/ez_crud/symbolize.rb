module EzCrud::Symbolize

  def self.included base
    base.send :include, InstanceMethods
    base.extend ClassMethods
  end

  module InstanceMethods
    # Return an attribute's value as a symbol
    def read_and_symbolize_attribute (attr_name)
      value = read_attribute(attr_name)
      value.blank? ? nil : value.to_sym
    end
  end

  module ClassMethods
    # as symbols. The table column should be created of type string.
    def symbolize (*attr_names)
      attr_names.each do |attr_name|
        attr_name = attr_name.to_s
        class_eval("def #{attr_name}; read_and_symbolize_attribute('#{attr_name}'); end")
        class_eval("def #{attr_name}= (value); write_attribute('#{attr_name}', value.to_s); end")
      end
    end
  end
end
