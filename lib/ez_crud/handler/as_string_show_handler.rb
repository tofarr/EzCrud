module EzCrud
  module Handler
    class AsStringShowHandler
      def match(value) true end
      def to_html(value) CGI::escapeHTML(value.to_s) end
    end
  end
end
