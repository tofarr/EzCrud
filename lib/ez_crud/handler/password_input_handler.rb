require "ez_crud/attrs"
require "ez_crud/handler/input_handler"

module EzCrud
  module Handler
    class PasswordInputHandler < EzCrud::Handler::InputHandler
      def match(model, attr, params)
        attr.to_s.include? "password"
      end

      def html_for_input(form, model, attr, id, params)
        form.password_field attr, class: "text-input password-input", id: id
      end
    end
  end
end
