module EzCrud
  class UpdateAllJobSpec < ApplicationRecord

    def process_model(model, updates, errors)
      model.assign_attributes(updates)
      model.save ? 1 : 0
    end
  end
end
