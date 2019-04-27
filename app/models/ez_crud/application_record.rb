puts "TODO:DeleteMe!"
module EzCrud
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
