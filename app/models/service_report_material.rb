class ServiceReportMaterial < ApplicationRecord
  belongs_to :service_report
  belongs_to :material

  before_save :calculate_pre_tax_total

  def calculate_pre_tax_total
    self.pre_tax_total = material.price * quantity
  end
end
