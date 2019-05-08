require "ez_crud/attrs"

require "ez_crud/handler/to_html_show_handler"
require "ez_crud/handler/boolean_show_handler"
require "ez_crud/handler/active_record_show_handler"
require "ez_crud/handler/enumerable_show_handler"
require "ez_crud/handler/as_string_show_handler"

require "ez_crud/handler/text_area_handler"
require "ez_crud/handler/password_input_handler"
require "ez_crud/handler/select_input_handler"
require "ez_crud/handler/checkbox_input_handler"
require "ez_crud/handler/input_handler"

module EzCrud
  class Html

    @show_handlers = [
      EzCrud::Handler::ToHtmlShowHandler.new,
      EzCrud::Handler::BooleanShowHandler.new,
      EzCrud::Handler::ActiveRecordShowHandler.new,
      EzCrud::Handler::EnumerableShowHandler.new,
      EzCrud::Handler::AsStringShowHandler.new
    ]
    @input_handlers = [
      EzCrud::Handler::TextAreaHandler.new,
      EzCrud::Handler::PasswordInputHandler.new,
      EzCrud::Handler::SelectInputHandler.new,
      EzCrud::Handler::CheckboxInputHandler.new,
      EzCrud::Handler::InputHandler.new
    ]

    def self.show_handlers
      @show_handlers
    end

    def self.input_handlers
      @input_handlers
    end

    def self.show_handler(value)
      @show_handlers.detect{|handler| handler.match(value) }
    end

    def self.show(value)
      self.show_handler(value).to_html(value).html_safe
    end

    def self.inputs(form, model, params={})
      output=StringIO.new
      EzCrud::Attrs.param_names(model.class, params).each_with_index do |param, index|
        output << self.input(form, model, param, params[param] || {})
      end
      output.string.html_safe
    end

    def self.input(form, model, attr, params={})
      @input_handlers.detect{|handler| handler.match(model, attr, params) }.to_html(form, model, attr, params).html_safe
    end

  end
end
