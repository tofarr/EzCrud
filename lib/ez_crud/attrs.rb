module EzCrud

  class Attrs

    def self.show(subject, only=nil, except=Rails.configuration.ez_crud_show_except)
      attr_names = subject.is_a?(Array) ? subject : subject.attribute_names.map(&:to_sym)
      if only.present?
        to_remove = only - attr_names
        attr_names = only - to_remove
      end
      attr_names -= except if except.present?
      attr_names
    end

    def self.summarize(subject, only=nil, except=Rails.configuration.ez_crud_summarize_except, max_attrs=Rails.configuration.ez_crud_summarize_max_attrs)
      attr_names = if subject.is_a?(Array)
                     subject
                   else
                     subject.attribute_names.reject{|c|subject.attribute_types[c].type==:text}.map(&:to_sym)
                   end
      if only.present?
        to_remove = only - attr_names
        attr_names = only - to_remove
      end
      attr_names -= except if except.present?
      attr_names

      attr_names

    end

  end

end
