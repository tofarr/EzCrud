class Comment < ApplicationRecord
  belongs_to :doohickey

  def to_s
    message.length > 100 ? (message[0..100]+'...') : message
  end
end
