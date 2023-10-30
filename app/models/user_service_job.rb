class UserServiceJob < ApplicationRecord
  belongs_to :service_job
  belongs_to :user
end
