require "ez_crud/attrs"

require "ez_crud/handler/to_html_show_handler"
require "ez_crud/handler/boolean_show_handler"
require "ez_crud/handler/active_record_show_handler"
require "ez_crud/handler/enumerable_show_handler"
require "ez_crud/handler/as_string_show_handler"

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

    def self.inputs(model, params={})
      output=StringIO.new
      EzCrud::Attrs.param_names(model.class, params).each_with_index do |param, index|
        id = "#{model.class.name.underscore}_#{index}"
        input_params = params[param] || {}
        title = input_params[:title] || self.title_for(param)
        output << "<div class=\"field\">"
        output << "<label for=\"#{id}\" class=\"label\">#{title}\</label>"
        output << self.input(model, param, id, input_params)
        output << "</div>"
      end
      output.string.html_safe
    end

    def self.input(model, attr, id=nil, params={})
      @input_handlers.detect{|handler| handler.match(model, attr, params) }.to_html(model, attr, id, params).html_safe
    end

    def self.title_for(param)
      param = param.to_s
      if(param.ends_with?('_ids'))
        param = param[0...-4].pluralize
      elsif param.ends_with?('_id')
        param = param[0...-3]
      end
      I18n.t(param, default: param.titleize)
    end

  end
end
