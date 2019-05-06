require "ez_crud/attrs"

module EzCrud
  module Handler
    class InputHandler
      def match(model, attr, params)
        EzCrud::Attrs.attr_types(model.class)[attr] == :string && attr.to_s.include?("password")
      end
      def to_html(model, attr, id, params)
        "<input type=\"password\" name=\"#{model.class.name.underscore}[#{attr}]\" class=\"text-input password\"#{id ? " id=\"#{id}\"" : ""} value=\"#{CGI::escapeHTML(model.send(attr).to_s)}\" />"
      end
    end
  end
end
