module EzCrud
  module Handler
    class ToHtmlShowHandler
      def match(value) value.respond_to?(:to_html) end
      def to_html(value) value.to_html end
    end
  end
end
