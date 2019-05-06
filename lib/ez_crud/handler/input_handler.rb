require "ez_crud/attrs"

module EzCrud
  module Handler
    class InputHandler
      def match(model, attr, params) true end
      def to_html(model, attr, id, params)
        type = EzCrud::Attrs.attr_types(model.class)[attr]
        "<input type=\"text\" name=\"#{model.class.name.underscore}[#{attr}]\" class=\"text-input #{type}\"#{id ? " id=\"#{id}\"" : ""} value=\"#{CGI::escapeHTML(model.send(attr).to_s)}\" />"
      end
    end
  end
end
