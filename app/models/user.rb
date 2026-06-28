class User < ApplicationRecord
  has_secure_password

  has_many :pets, foreign_key: :user_id, dependent: :destroy
  has_many :adoption_applications, foreign_key: :applicant_id, dependent: :destroy
  has_many :sent_messages, class_name: 'Message', foreign_key: :sender_id, dependent: :destroy
  has_many :received_messages, class_name: 'Message', foreign_key: :receiver_id, dependent: :destroy

  validates :phone, presence: true, uniqueness: true, format: { with: /\A1[3-9]\d{9}\z/, message: '格式不正确' }
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  validates :nickname, length: { maximum: 50 }

  def masked_wechat
    return nil if wechat.blank?
    return wechat if wechat.length <= 2

    "#{wechat[0]}***#{wechat[-1]}"
  end
end
