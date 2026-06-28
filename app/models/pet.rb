class Pet < ApplicationRecord
  belongs_to :user
  has_many :pet_images, dependent: :destroy
  has_many :adoption_applications, dependent: :destroy
  has_many :messages, dependent: :destroy

  SPECIES = %w[dog cat other].freeze
  SIZES = %w[small medium large].freeze
  GENDERS = %w[male female unknown].freeze
  SOURCES = %w[rescued abandoned].freeze
  STATUSES = %w[listed unlisted adopted].freeze

  validates :name, presence: true
  validates :species, presence: true, inclusion: { in: SPECIES }
  validates :source, presence: true, inclusion: { in: SOURCES }
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :size, inclusion: { in: SIZES }, allow_nil: true
  validates :gender, inclusion: { in: GENDERS }, allow_nil: true
  validates :age_months, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

  accepts_nested_attributes_for :pet_images, allow_destroy: true

  scope :listed, -> { where(status: 'listed') }
  scope :by_species, ->(species) { where(species: species) if species.present? }
  scope :by_size, ->(size) { where(size: size) if size.present? }

  def listed?
    status == 'listed'
  end

  def unlisted?
    status == 'unlisted'
  end

  def adopted?
    status == 'adopted'
  end

  def list!
    update!(status: 'listed')
  end

  def unlist!
    update!(status: 'unlisted')
  end

  def adopt!
    update!(status: 'adopted')
  end
end
