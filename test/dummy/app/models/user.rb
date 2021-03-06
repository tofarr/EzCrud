require "ez_crud/symbolize"

class User < ApplicationRecord

  include EzCrud::Symbolize
  symbolize :dinner_choice

  has_secure_password
  has_one_attached :avatar

  validates :email, allow_blank: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :homepage, allow_blank: true, format: URI::regexp(%w(http https))

  validates :avatar, allow_blank: true, blob: { content_type: :image }

  validates :dinner_choice, presence: true, inclusion: { in: %i(chicken fish vegan) }

  def preferred_size_for(attr)
    return attr == :avatar ? [256, 256] : nil
  end
end
