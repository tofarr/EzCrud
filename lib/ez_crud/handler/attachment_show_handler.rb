module EzCrud
  module Handler
    class AttachmentShowHandler
      def match(value) value.is_a?(ActiveStorage::Attached) end
      def to_html(value)
        return "" unless value.attachment

        url = Rails.application.routes.url_helpers.rails_blob_path(value, {only_path: true})

        type = value.content_type
        if type == "image/jpg" || type == "image/jpeg" || type == "image/gif" || type == "image/png"
          "<img src=\"#{url}\" class=\"image upload-image\" />"
        else
          "<a href=\"#{url}\" class=\"upload-file-link\">#{value.filename}</a>"
        end
      end
    end
  end
end
