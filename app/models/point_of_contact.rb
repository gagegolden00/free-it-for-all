class PointOfContact < ApplicationRecord
  belongs_to :customer

  validates :name, presence: true
end
