module EzCrud
  class DestroyAllJobSpec < ApplicationRecord

    def process_model(model, params, errors)
      if model
        model.destroy
        1
      else
        0
      end
    end
  end
end
