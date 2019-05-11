require "ez_crud/attrs"

module EzCrud
  module Handler
    class InputForHandler

      def match(model, attr, params)
        model.respond_to?(:input_for) && model.input_for(attr).present?
      end

      def to_html(form, model, attr, params)
        model.input_for(attr).to_html(form, model, attr, params)
      end
    end
  end
end
