class UserServiceJob < ApplicationRecord
  belongs_to :service_job
  belongs_to :user

  validates :date, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :start_time_before_end_time

  scope :active_users_for_service_job, lambda { |service_job_id|
    joins(:user)
      .select('users.*, user_service_jobs.id AS user_service_job_id, user_service_jobs.*')
      .where(discarded_at: nil, service_job_id:)
  }

  private

  def start_time_before_end_time
    return if start_time && end_time && !start_time.after?(end_time)
    errors.add(:base, 'The start time must be before the end time for any given day')
  end
end
