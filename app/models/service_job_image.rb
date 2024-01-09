class ServiceJobImage < ApplicationRecord
  belongs_to :service_job
  include ImageUploader::Attachment(:image)
end
