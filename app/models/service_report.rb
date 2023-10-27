class ServiceReport < ApplicationRecord
  has_many :service_report_materials
  has_many :materials, through: :service_report_materials

  accepts_nested_attributes_for :service_report_materials

  private

  def quantity_blank?(attributes)
    result = attributes['quanity'].blank?
    result
  end

end
