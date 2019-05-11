require "ez_crud/attrs"
require "ez_crud/handler/input_handler"

module EzCrud
  module Handler
    class SelectInputHandler < EzCrud::Handler::InputHandler

      def match(model, attr, params)
        return true if params[:options]
        return true if attr_assoc(model, attr).present?
        model.class.validators_on(attr).detect{|v|v.is_a?(ActiveModel::Validations::InclusionValidator)}.present?
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
        unless params[:no_ajax]
          if params[:data_store]
            input_params["data-store"] = params[:data_store]
          elsif assoc
            input_params["data-store"] = assoc.klass.name.pluralize.underscore
          end
        end
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
          validator = model.class.validators_on(attr).detect{|v|v.is_a?(ActiveModel::Validations::InclusionValidator)}
          if validator
            options = validator.options[:in]
          else
            options = assoc.klass.all
            options = options.where(id: ids) unless params[:no_ajax]
          end
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
        return option[1] || option[0] if option.is_a?(Array)
        return option if option.is_a?(String) || option.is_a?(Symbol)
        return option.id
      end

      def opt_title(option, title_attr)
        return option[0] if option.is_a?(Array)
        return option.send(title_attr) if title_attr
        return I18n.t(option, default: option.to_s.titleize) if option.is_a?(Symbol) || option.is_a?(String)
        option.to_s
      end
    end
  end
end
