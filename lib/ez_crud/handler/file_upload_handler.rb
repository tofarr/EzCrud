require "ez_crud/attrs"
require "ez_crud/handler/input_handler"

module EzCrud
  module Handler
    class FileUploadHandler < EzCrud::Handler::InputHandler
      def match(model, attr, params)
        EzCrud::Attrs.attr_types(model.class)[attr] == ActiveStorage::Attachment
      end

      def html_for_input(form, model, attr, id, params)
        form.file_field attr, direct_upload: false, class: 'form-upload'
        #type = EzCrud::Attrs.attr_types(model.class)[attr]
        #form.text_field(attr, class: "text-input #{type}", id: id)
        #"TODO: File Upload"
      end

    end
  end
end
