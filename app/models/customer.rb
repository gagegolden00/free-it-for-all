class Customer < ApplicationRecord
  has_one :point_of_contact, :dependent => :destroy
  has_many :customer_regions
  has_many :regions, through: :customer_regions
  has_many :customer_service_jobs, through: :customer_service_jobs


  accepts_nested_attributes_for :point_of_contact
  accepts_nested_attributes_for :customer_regions

  before_discard :discard_necessary_associated_records

  private

  def discard_necessary_associated_records
    self.point_of_contact.discard if self.point_of_contact.present?
  end

end
