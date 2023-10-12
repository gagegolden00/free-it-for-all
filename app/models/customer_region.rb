class CustomerRegion < ApplicationRecord
  belongs_to :customer
  belongs_to :region
end
