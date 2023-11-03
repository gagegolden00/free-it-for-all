class ServiceReport < ApplicationRecord
  has_many :service_report_materials
  has_many :materials, through: :service_report_materials
  has_many :purchase_orders

  accepts_nested_attributes_for :service_report_materials

  validates :service_job_id, presence: true
  # validates :service_report_number, presence: true
  validates :equipment_model, presence: true
  validates :equipment_serial, presence: true
  validates :description, presence: true


  scope :materials_used, ->(service_report) {
    joins(service_report_materials: :material)
      .where(id: service_report.id)
      .where('service_report_materials.quantity > 0')
      .select('materials.name, materials.price, service_report_materials.quantity, service_report_materials.pre_tax_total')
  }

  private

end
