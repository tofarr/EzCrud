class User < ApplicationRecord

  has_secure_password
  has_one_attached :avatar

  validates :email, allow_blank: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :homepage, allow_blank: true, format: URI::regexp(%w(http https))

  validates :avatar, allow_blank: true, blob: { content_type: :image }

  def preferred_size_for(attr)
    puts "TRACE:400:#{attr}"
    return attr == :avatar ? [256, 256] : nil
  end
end
