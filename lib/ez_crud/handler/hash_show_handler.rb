module EzCrud
  module Handler
    class HashShowHandler
      def match(value) value.is_a?(Hash) end
      def to_html(value)
        buffer = StringIO.new
        buffer << "<div class=\"hash\">"
        value.each do |k,v|
          buffer << "<div class=\"field array-item\">"
          buffer << "<label class=\"label\">#{EzCrud::Html.show(k)}</label>"
          buffer << '<div class=\"show\">'
          buffer << EzCrud::Html.show(v)
          buffer << '</div>'
          buffer << '</div>'
        end
        buffer << "</div>"
        buffer.string
      end
    end
  end
end
