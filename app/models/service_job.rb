class ServiceJob < ApplicationRecord
  validates :job_number, null: false
  validates :status, null: false

  has_one :customer
  has_one :salesman
  has_one :work_site
  has_many :purchase_orders

  
  # has_many :service_reports # This is for a later feature
end
