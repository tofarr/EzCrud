class Category < ApplicationRecord

  has_and_belongs_to_many :doohickeys

  def self.summary_attrs
    return [:title, :updated_at]
  end
end
