class CustomerServiceJob < ApplicationRecord
  belongs_to :customer
  belongs_to :service_job
end
