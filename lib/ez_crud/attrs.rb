module EzCrud

  class Attrs

    @outputs = {}
    @inputs = {}
    @types = {}

    def self.show(subject, params={})
      params[:except] = Rails.configuration.ez_crud_summarize_except unless params[:except]
      self.output(subject, params)
    end

    def self.summarize(subject, params={})
      return self.only_except(subject, subject.summary_attrs, params) if subject.respond_to?(:summary_attrs)
      params[:except] = Rails.configuration.ez_crud_summarize_except unless params[:except]
      params[:except_types] = Rails.configuration.ez_crud_summarize_except_types unless params[:except_types] || params[:only]
      params[:max_attrs] = Rails.configuration.ez_crud_summarize_max_attrs unless params[:max_attrs]
      self.output(subject, params)
    end

    def self.param_names(subject, params={})
      params[:except] = Rails.configuration.ez_crud_params_except unless params[:except]
      self.input(subject, params)
    end

    def self.output(subject, params={})
      attrs = nil
      if subject.respond_to?(:output_attrs)
        attrs = subject.output_attrs
      else
        attrs = @outputs[subject]
        return attrs if attrs
        attrs = subject.attribute_names.map(&:to_sym)
        subject.reflect_on_all_associations.each do |assoc|
          if assoc.is_a?(ActiveRecord::Reflection::BelongsToReflection)
            attrs[attrs.index(assoc.foreign_key.to_sym)] = assoc.name
          else
            attrs << assoc.name
          end
        end
        @outputs[subject] = attrs unless Rails.env.development?
      end
      self.only_except(subject, attrs, params)
    end

    def self.input(subject, params={})
      attrs = nil
      if subject.respond_to?(:input_attrs)
        attrs = subject.input_attrs
      else
        attrs = @inputs[subject]
        return attrs if attrs
        attrs = subject.attribute_names.map(&:to_sym)
        subject.reflect_on_all_associations.each do |assoc|
          unless assoc.is_a?(ActiveRecord::Reflection::BelongsToReflection)
            attrs << "#{assoc.name.to_s.singularize}_ids".to_sym
          end
        end
        if attrs.include? :password_digest
          attrs << :password
          attrs << :password_confirmation
        end
        @inputs[subject] = attrs unless Rails.env.development?
      end
      self.only_except(subject, attrs, params)
    end

    def self.only_except(subject, attrs, params)
      attrs = attrs & params[:only] if params[:only].present?
      attrs = attrs - params[:except] if params[:except].present?
      if params[:except_types].present?
        attr_types = self.attr_types(subject)
        params[:except_types].each do |type|
          attrs = attrs.reject do |attr|
            t = attr_types[attr]
            t && params[:except_types].include?(t)
          end
        end
      end
      if(params[:max_attrs])
        attrs = attrs.take(params[:max_attrs])
      end
      attrs
    end

    def self.attr_types(subject)
      if subject.respond_to?(:attr_types)
        subject.attr_types
      else
        ret = @types[subject]
        return ret if ret
        ret = {}
        subject.attribute_types.each { |k, v| ret[k.to_sym] = v.type }
        subject.reflect_on_all_associations.each { |assoc| ret[assoc.name] = assoc.klass.name.underscore.to_sym }
        @types[subject] = ret unless Rails.env.development?
        ret
      end
    end

    def self.title_attr(subject)
      attr_types = self.attr_types(subject)
      return :title if attr_types[:title] == :string
      entry = attr_types.detect do |k, v|
        v == :string
      end
      return entry ? entry[0] : nil
    end

  end
end
