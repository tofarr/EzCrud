module EzCrud
  module Handler
    class BooleanShowHandler
      def match(value) value.is_a?(TrueClass) || value.is_a?(FalseClass) end
      def to_html(value) "<input type='checkbox' disabled='true' class='boolean #{value}' checked='#{value}' />" end
    end
  end
end
