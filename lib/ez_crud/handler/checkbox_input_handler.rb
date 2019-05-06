require "ez_crud/attrs"

module EzCrud
  module Handler
    class CheckboxInputHandler
      def match(model, attr, params)
        EzCrud::Attrs.attr_types(model.class)[attr] == :boolean
      end
      def to_html(model, attr, id, params)
        name = "#{model.class.name.underscore}[#{attr}]"
        type = EzCrud::Attrs.attr_types(model.class)[attr]
        "<input type=\"hidden\" name=\"#{name}\" value=\"0\" /><input type=\"checkbox\" name=\"#{name}\" class=\"checkbox-input #{type}\"#{id ? " id=\"#{id}\"" : ""} value=\"1\" checked=\"#{model.send(attr)}\" />"
      end
    end
  end
end
