class Customer < ApplicationRecord
  has_one :point_of_contact, dependent: :destroy, required: false
  belongs_to :region, required: false
  has_many :service_jobs

  validates :name, presence: true

  accepts_nested_attributes_for :point_of_contact, reject_if: :name_blank?

  before_discard :discard_necessary_associated_records

  validates :name, presence: true

  private

  def discard_necessary_associated_records
    point_of_contact.discard if point_of_contact.present?
  end

  def name_blank?(attributes)
    attributes['name'].blank?
  end
end
