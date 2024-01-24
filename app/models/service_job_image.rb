class ServiceJobImage < ApplicationRecord
  include ImageUploader::Attachment(:image)
  belongs_to :service_job
  belongs_to :user

  validates :image, presence: true
  validates :user_id, presence: true
end
