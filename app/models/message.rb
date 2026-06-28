class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'
  belongs_to :pet
  belongs_to :application, class_name: 'AdoptionApplication'

  validates :title, presence: true
  validates :content, presence: true

  scope :unread, -> { where(is_read: false) }
  scope :read, -> { where(is_read: true) }
  scope :by_receiver, ->(receiver_id) { where(receiver_id: receiver_id) }

  def mark_as_read!
    update!(is_read: true)
  end
end
