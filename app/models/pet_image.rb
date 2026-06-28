class PetImage < ApplicationRecord
  belongs_to :pet

  validates :url, presence: true
end
