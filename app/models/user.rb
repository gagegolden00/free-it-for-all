class User < ApplicationRecord

  has_many :user_service_jobs
  has_many :service_jobs, through: :user_service_jobs
  has_many :service_reports, through: :service_jobs
  has_many :time_logs

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { admin: 'admin', technician: 'technician' }

  validates :name, presence: true
  validates :role, presence: true
  validates :email, presence: true
  validates :password, presence: true

  # This makes sure discarded users cant login
  default_scope -> { kept }

  scope :only_admins, -> {
    where(role: 'admin')
  }

  scope :only_technicians, -> {
    where(role: 'technician')
  }

  scope :all_with_time_log_totals_in_time_period, ->(start_date, end_date) {
    left_outer_joins(:time_logs)
      .where(time_logs: {created_at: start_date..end_date})
      .group('users.id')
      .select(
        'users.id as user_id',
        'users.name',
        'SUM(regular_minutes) AS total_regular_minutes',
        'SUM(overtime_minutes) AS total_overtime_minutes',
        'SUM(double_time_minutes) AS total_double_time_minutes',
        'SUM(mileage) AS total_mileage'
      )
  }

  scope :all_with_no_time_logs_in_time_period, ->(start_date, end_date) {
    only_technicians
      .where.not(id: User.only_technicians
                       .joins(:time_logs)
                       .where(time_logs: { created_at: start_date..end_date })
                       .distinct
                       .pluck(:id))
  }

  scope :weekly_logs, ->(user, start_date, end_date) {
    only_technicians
      .joins(:service_reports, :time_logs)
      .where(service_report: { created_at: start_date..end_date })
  }


end
