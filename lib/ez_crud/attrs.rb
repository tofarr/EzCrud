module EzCrud

  class Attrs

    def self.show(subject, params={})
      params[:except] = Rails.configuration.ez_crud_summarize_except unless params[:except]
      self.output(subject, params)
    end

    def self.summarize(subject, params={})
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
        attrs = subject.attribute_names.map(&:to_sym)
        subject.reflect_on_all_associations.each do |assoc|
          if assoc.is_a?(ActiveRecord::Reflection::BelongsToReflection)
            attrs[attrs.index(assoc.foreign_key.to_sym)] = assoc.name
          else
            attrs << assoc.name
          end
        end
      end
      self.only_except(subject, attrs, params)
    end

    def self.input(subject, params={})
      attrs = nil
      if subject.respond_to?(:input_attrs)
        attrs = subject.input_attrs
      else
        attrs = subject.attribute_names.map(&:to_sym)
        subject.reflect_on_all_associations.each do |assoc|
          unless assoc.is_a?(ActiveRecord::Reflection::BelongsToReflection)
            attrs << "#{assoc.name.singularize}_ids".to_sym
          end
        end
      end
      self.only_except(subject, attrs, params)
    end

    def self.only_except(subject, attrs, params)
      attrs = attrs & params[:only] if params[:only].present?
      attrs = attrs - params[:except] if params[:except].present?
      if params[:except_types].present?
        params[:except_types].each do |type|
          attrs.reject do |attr|
            type = subject.attribute_types[attr.to_s]&.type
            type && params[:except_types].include?(type)
          end
        end
      end
      if(params[:max_attrs])
        attrs = attrs.take(params[:max_attrs])
      end
      attrs
    end

  end
end
