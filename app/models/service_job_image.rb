class ServiceJobImage < ApplicationRecord
  include ImageUploader::Attachment(:image)
  belongs_to :service_job

  validates :image_data, presence: true
end
