class Region < ApplicationRecord
  has_many :customer_regions
  has_many :customers, through: :customer_regions
  has_many :service_jobs
end
