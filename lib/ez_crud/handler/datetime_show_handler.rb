module EzCrud
  module Handler
    class DatetimeShowHandler
      def match(value) value.is_a?(ActiveSupport::TimeWithZone) end
      def to_html(value) value.iso8601 end
    end
  end
end
