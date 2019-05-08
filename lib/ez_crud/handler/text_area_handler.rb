require "ez_crud/attrs"
require "ez_crud/handler/input_handler"

module EzCrud
  module Handler
    class TextAreaHandler < EzCrud::Handler::InputHandler

      def match(model, attr, params)
        EzCrud::Attrs.attr_types(model.class)[attr] == :text
      end

      def html_for_input(form, model, attr, id, params)
        form.text_area(attr, class: "text-area", id: id, "data-markdown": params[:markdown] || Rails.configuration.es_crud_markdown)
      end
      
    end
  end
end
