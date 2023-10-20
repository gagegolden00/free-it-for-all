class Region < ApplicationRecord
  has_many :customers
  has_many :service_jobs
end
