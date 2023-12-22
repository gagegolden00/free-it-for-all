class User < ApplicationRecord
  has_many :user_service_jobs
  has_many :service_jobs, through: :user_service_jobs
  has_many :service_reports, through: :service_jobs
  has_many :time_logs
  has_many :notifications, as: :recipient, dependent: :destroy

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

  scope :only_admins, lambda {
    where(role: 'admin')
  }

  scope :only_technicians, lambda {
    where(role: 'technician')
  }

  scope :all_with_time_log_totals_in_time_period, lambda { |start_date, end_date, order|
    find_by_sql([<<-SQL, start_date, end_date])
      SELECT
        users.id AS user_id,
        users.name,
        COALESCE(SUM(regular_minutes), 0) AS total_regular_minutes,
        COALESCE(SUM(overtime_minutes), 0) AS total_overtime_minutes,
        COALESCE(SUM(double_time_minutes), 0) AS total_double_time_minutes,
        COALESCE(SUM(mileage), 0) AS total_mileage
      FROM
        users
      LEFT OUTER JOIN
        time_logs ON time_logs.user_id = users.id AND time_logs.created_at BETWEEN ? AND ?
      WHERE
        users.discarded_at IS NULL
      GROUP BY
        users.id, users.name
      ORDER BY
        #{order.present? ? order : 'name ASC'}
    SQL
  }

  scope :daily_schedule_for_techs_by_date, lambda { |selected_date|
    find_by_sql([<<-SQL, { selected_date: }])
    SELECT
    users.id,
    users.name,
    array_agg(DISTINCT user_service_jobs.id) AS user_service_job_ids,
    array_agg(DISTINCT user_service_jobs.start_time) AS start_times,
    array_agg(DISTINCT user_service_jobs.end_time) AS end_times,
    array_agg(DISTINCT service_jobs.id) AS service_job_ids
  FROM
    "users"
  LEFT OUTER JOIN
    user_service_jobs
  ON
    user_service_jobs.user_id = users.id
    AND user_service_jobs.date = '2023-12-25'
  LEFT OUTER JOIN
    service_jobs
  ON
    service_jobs.id = user_service_jobs.service_job_id
  WHERE
    "users"."discarded_at" IS NULL
    AND "users"."role" = 'technician'
    AND "users"."discarded_at" IS NULL
  GROUP BY
    users.id, users.name;
    SQL
  }

  pg_search_scope :search_by_name,
                  against: [:name],
                  using: {
                    tsearch: { prefix: true, dictionary: 'english' }
                  }
end
