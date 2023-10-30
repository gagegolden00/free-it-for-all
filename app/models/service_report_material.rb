class ServiceReportMaterial < ApplicationRecord
  belongs_to :service_report
  belongs_to :material
end
