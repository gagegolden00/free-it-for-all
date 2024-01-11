class ServiceJobImage < ApplicationRecord
  include ImageUploader::Attachment(:image)
  belongs_to :service_job

  validates :image, presence: true
end
