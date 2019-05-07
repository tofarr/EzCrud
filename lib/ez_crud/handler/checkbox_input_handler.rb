require "ez_crud/attrs"
require "ez_crud/handler/input_handler"

module EzCrud
  module Handler
    class CheckboxInputHandler < EzCrud::Handler::InputHandler
      def match(model, attr, params)
        EzCrud::Attrs.attr_types(model.class)[attr] == :boolean
      end
      def html_for_input(form, model, attr, id, params)
        form.check_box attr, class: "checkbox-input"
      end
    end
  end
end
