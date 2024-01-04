class WorkSite < ApplicationRecord
  has_many :service_jobs

  validates :name, presence: true
end
