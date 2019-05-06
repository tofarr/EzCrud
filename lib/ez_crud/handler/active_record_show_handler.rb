module EzCrud
  module Handler
    class ActiveRecordShowHandler
      def match(value) value.is_a?(ActiveRecord::Base) end
        def to_html(value)
          attr = EzCrud::Attrs.title_attr(value.class)
          "<div class=\"reference #{value.class.name.underscore}\">#{CGI::escapeHTML(attr ? value.send(attr) : value.to_s)}</div>"
        end
    end
  end
end
