module EzCrud
  module Handler
    class SymbolShowHandler
      def match(value) value.is_a?(Symbol) end
      def to_html(value) I18n.t(value, default: value.to_s.titleize) end
    end
  end
end
