class UserServiceJob < ApplicationRecord
  belongs_to :service_job
  belongs_to :user

  scope :active_users_for_service_job, ->(service_job_id) do
    joins(:user)
      .select('users.*, user_service_jobs.id AS user_service_job_id, user_service_jobs.*')
      .where(discarded_at: nil, service_job_id: service_job_id)
  end

end
