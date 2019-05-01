require "ez_crud/attrs"

module EzCrud
  class Html

    def self.show(value)
      if value.respond_to?(:to_html)
        value.to_html
      elsif value.is_a?(ActiveRecord::Base)
        attr = EzCrud::Attrs.title_attr(value.class)
        (attr ? value.send(attr) : value)
      elsif value.is_a?(ActiveRecord::Associations::CollectionProxy)
        value.inject(StringIO.new){ |output, v| output << self.show(v) }.string
      else
        value
      end
    end
  end
end
