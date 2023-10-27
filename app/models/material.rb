class Material < ApplicationRecord
  has_many :service_report_materials
  has_many :materials, through: :service_report_materials

  validates :name, presence: true, uniqueness: true

end
