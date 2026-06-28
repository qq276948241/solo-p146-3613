class AdoptionApplication < ApplicationRecord
  belongs_to :pet
  belongs_to :applicant, class_name: 'User'
  has_many :messages, dependent: :destroy

  STATUSES = %w[pending approved rejected].freeze

  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :applicant_name, presence: true
  validates :applicant_phone, presence: true, format: { with: /\A1[3-9]\d{9}\z/, message: '格式不正确' }
  validates :pet_id, uniqueness: { scope: :applicant_id, message: '您已提交过该宠物的领养申请' }

  validate :pet_must_be_listed, on: :create
  validate :cannot_apply_own_pet, on: :create

  scope :by_status, ->(status) { where(status: status) if status.present? }
  scope :pending, -> { where(status: 'pending') }
  scope :approved, -> { where(status: 'approved') }
  scope :rejected, -> { where(status: 'rejected') }

  def pending?
    status == 'pending'
  end

  def approved?
    status == 'approved'
  end

  def rejected?
    status == 'rejected'
  end

  def approve!
    return false unless pending?

    transaction do
      update!(status: 'approved')
      pet.adopt!
      send_match_notifications
    end
    true
  end

  def reject!
    return false unless pending?

    update!(status: 'rejected')
    true
  end

  private

  def pet_must_be_listed
    errors.add(:pet, '该宠物当前不可领养') unless pet&.listed?
  end

  def cannot_apply_own_pet
    errors.add(:pet, '不能申请自己登记的宠物') if pet && applicant_id == pet.user_id
  end

  def send_match_notifications
    rescuer = pet.user
    applicant_user = applicant

    Message.create!(
      title: '领养申请已通过',
      content: "您对宠物「#{pet.name}」的领养申请已通过！救助人微信号：#{rescuer.wechat.presence || '暂未填写'}，请尽快联系。",
      sender: rescuer,
      receiver: applicant_user,
      pet: pet,
      application: self
    )

    Message.create!(
      title: '您的宠物有新的领养人',
      content: "您登记的宠物「#{pet.name}」的领养申请已通过！申请人：#{applicant_name}，联系电话：#{applicant_phone}，微信号：#{applicant_wechat.presence || '暂未填写'}。",
      sender: applicant_user,
      receiver: rescuer,
      pet: pet,
      application: self
    )
  end
end
