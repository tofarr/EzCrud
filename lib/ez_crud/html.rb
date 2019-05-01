require "ez_crud/attrs"

module EzCrud
  class Html

    @htmlifier = {
      TrueClass: Proc.new{|v| "<input type='checkbox' disabled='true' class='boolean true' checked='true' />".html_safe },
      FalseClass: Proc.new{|v| "<input type='checkbox' disabled='true' class='boolean false' />".html_safe }
    }

    def self.register(visualizer, *types)
      types.each{|type| @htmlifier[type] = visualizer }
    end

    def self.show(value)
      if value.respond_to?(:to_html)
        value.to_html.html_safe
      elsif htmlifier = @htmlifier[value.class.name.to_sym]
        htmlifier.call(value)
      elsif value.is_a?(ActiveRecord::Base)
        attr = EzCrud::Attrs.title_attr(value.class)
        "<div class=\"reference #{value.class.name.underscore}\">#{CGI::escapeHTML(attr ? value.send(attr) : value.to_s)}</div>".html_safe
      elsif value.is_a?(ActiveRecord::Associations::CollectionProxy)
        value.inject(StringIO.new){ |output, v| output << self.show(v) }.string.html_safe
      else
        value
      end
    end
  end
end
