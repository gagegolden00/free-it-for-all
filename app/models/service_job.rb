class ServiceJob < ApplicationRecord
  validates :job_number, null: false
  validates :status, null: false

  belongs_to :customer
  belongs_to :region
  has_one :salesman
  has_one :work_site
  has_many :purchase_orders
  has_many :users

  # has_many :service_reports # This is for a later feature

end
