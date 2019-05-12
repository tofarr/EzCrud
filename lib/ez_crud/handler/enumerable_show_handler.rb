module EzCrud
  module Handler
    class EnumerableShowHandler
      def match(value) value.is_a?(Enumerable) end
      def to_html(value)
        buffer = StringIO.new
        buffer << "<ol class=\"array\">"
        value.each do |item|
          buffer << '<li>'
          buffer << EzCrud::Html.show(item)
          buffer << '</li>'
        end
        buffer << "</ol>"
        buffer.string
      end
    end
  end
end
