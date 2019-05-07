require "ez_crud/attrs"
require "ez_crud/handler/input_handler"

module EzCrud
  module Handler
    class SelectInputHandler < EzCrud::Handler::InputHandler

      def match(model, attr, params)
        return true if params[:options]
        attr_assoc(model, attr).present?
      end

      def attr_assoc(model, attr)
        s = attr.to_s;
        if s.ends_with? '_id'
          attr = s[0...-3].to_sym
        elsif s.ends_with? '_ids'
          attr = s[0...-4].pluralize.to_sym
        else
          return false
        end
        model.class.reflect_on_all_associations.detect { |assoc| assoc.name == attr }
      end

      def html_for_input(form, model, attr, id, params)
        assoc = attr_assoc(model, attr)
        input_params = { multiple: multi?(assoc, params), class: css_class(attr, assoc, params) }
        input_params["data-store"] = params[:data_store] || assoc.klass.name.pluralize.underscore unless params[:no_ajax]
        input_params["data-exclude-ids"] = params[:exclude_ids] if params[:exclude_ids]
        form.select attr, options(model, attr, assoc, params), {}, input_params
      end

      def multi?(assoc, params)
        params[:multi] || (assoc && (!assoc.is_a?(ActiveRecord::Reflection::BelongsToReflection)))
      end

      def css_class(attr, assoc, params)
        "select-input #{attr} #{multi?(assoc, params) ? "single" : "multi"} #{params[:no_ajax] ? "no-ajax" : ""} #{params[:class]}"
      end

      def options(model, attr, assoc, params)
        ids = Array.wrap(model.send(attr))
        options = nil
        if params[:options]
          options = params[:options]
        else
          options = assoc.klass.all
          options = options.where(id: ids) unless params[:no_ajax]
        end
        title_attr = assoc ? EzCrud::Attrs.title_attr(assoc.klass) : nil
        ret = []
        options.each do |option|
          id = opt_id(option)
          title = opt_title(option, title_attr)
          ret << [title, ids.include?(id), id]
        end
        ret
      end

      def opt_id(option)
        return option.is_a?(Array) ? (option[1] || option[0]) : option.id
      end

      def opt_title(option, title_attr)
        return option[0] if option.is_a?(Array)
        return option.send(title_attr) if title_attr
        option.to_s
      end
    end
  end
end
