class Customer < ApplicationRecord
  has_one :point_of_contact, dependent: :destroy
  belongs_to :region
  accepts_nested_attributes_for :point_of_contact
  accepts_nested_attributes_for :customer_regions

  before_discard :discard_necessary_associated_records

  validates :name, presence: true

  private

  def discard_necessary_associated_records
    point_of_contact.discard if point_of_contact.present?
  end
end
