require "ez_crud/attrs"
require "ez_crud/handler/input_handler"

module EzCrud
  module Handler
    class JsonInputHandler < EzCrud::Handler::InputHandler
      def match(model, attr, params)
        EzCrud::Attrs.attr_types(model.class)[attr] == :json
      end
      def html_for_input(form, model, attr, id, params)
        form.text_area attr, {
          class: "json-input",
          value: model.send(attr).to_json,
          "data-open": (params[:open] == nil) ? true : params[:open],
          "data-tabs": (params[:tabs] == nil) ? true : params[:tabs]
        }
      end
    end
  end
end
