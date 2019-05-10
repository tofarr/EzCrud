require "ez_crud/attrs"
require "ez_crud/handler/input_handler"

module EzCrud
  module Handler
    class FileUploadHandler < EzCrud::Handler::InputHandler

      def initialize
        @content_types = {}
        @show_handler = EzCrud::Handler::AttachmentShowHandler.new
      end

      def match(model, attr, params)
        EzCrud::Attrs.attr_types(model.class)[attr] == ActiveStorage::Attachment
      end

      def html_for_input(form, model, attr, id, params)
        value = model.send(attr)
        show = @show_handler.to_html(value)

        checkbox = ""
        if value.attachment
          destroy_id = id_for(model, "destroy_#{attr}")
          checkbox = "<div class=\"destroy\"><input type=\"checkbox\" id=\"#{destroy_id}\" name=\"#{model.class.name.underscore}[destroy_#{attr}]\" /><label for=\"#{destroy_id}\">#{I18n.t("destroy_#{attr}", default: "Delete #{attr.to_s.titleize}")}</label></div>"
        end

        file_params = {direct_upload: false, id: id, class: 'file-input'};
        ct = content_type(model.class, attr)
        file_params["data-content-type"] = ct if ct
        preferred_size = model.respond_to?(:preferred_size_for) ? model.preferred_size_for(attr) : nil
        if preferred_size
          file_params["data-preferred-width"] = preferred_size[0]
          file_params["data-preferred-height"] = preferred_size[1]
        end
        input = form.file_field attr, file_params

        "<div class=\"form-upload\">#{show}#{checkbox}<div class=\"file-input-container\">#{input}</div></div>"
      end

      def content_type(model_class, attr)
        attr_types = @content_types[model_class]
        @content_types[model_class] = attr_types = {} unless attr_types
        content_type = attr_types[attr]
        return content_type if content_type

        content_type = model_class.validators_on(attr).map{|v|(v&.options || {})[:content_type]}.detect{|t|t}
        unless content_type
          s = attr.to_s
          if s.include?("image") || s.include?("icon") || s.include?("avatar")
            Rails.logger.info("FileUploadHandler: Auto selecting content type image for #{model_class}\##{attr} - you may want to add a validation") if Rails.env.development?
            content_type = :image
          end
        end

        attr_types[attr] = content_type unless Rails.env.development?

        content_type

      end

    end
  end
end
