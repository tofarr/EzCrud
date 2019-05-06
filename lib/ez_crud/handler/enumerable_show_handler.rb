module EzCrud
  module Handler
    class EnumerableShowHandler
      def match(value) value.is_a?(Enumerable) end
      def to_html(value)
        value.inject(StringIO.new){ |output, v| output << EzCrud::Html.show(v) }.string
      end
    end
  end
end
