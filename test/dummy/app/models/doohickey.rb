class Doohickey < ApplicationRecord

  has_and_belongs_to_many :categories
  has_many :comments


  def as_json(params={})
    params = params.merge(methods: [:category_ids, :comment_ids]) unless params[:methods]
    super(params)
  end
end
