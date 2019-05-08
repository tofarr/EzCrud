require "ez_crud/attrs"

module EzCrud
  module Handler
    class InputHandler
      def match(model, attr, params) true end
      def to_html(form, model, attr, params)
        field_html(model, attr, params) do |id|
          html_for_input(form, model, attr, id, params)
        end
      end

      def html_for_input(form, model, attr, id, params)
        type = EzCrud::Attrs.attr_types(model.class)[attr]
        form.text_field(attr, class: "text-input #{type}", id: id)
      end

      def field_html(model, attr, params, &block)
        id = id_for(model, attr)
        "<div class=\"field\"><label for=\"#{id}\" class=\"label\">#{params[:title] || title_for(attr)}\</label><div class=\"input\">#{yield id}</div></div>"
      end

      def id_for(model, attr)
        "#{model.class.name.underscore}_#{model.id ? model.id : "new"}_#{attr}"
      end

      def title_for(attr)
        attr = attr.to_s
        if(attr.ends_with?('_ids'))
          attr = attr[0...-4].pluralize
        elsif attr.ends_with?('_id')
          attr = attr[0...-3]
        end
        I18n.t(attr, default: attr.titleize)
      end
    end
  end
end
