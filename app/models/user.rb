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
  find_by_sql([<<-SQL, { selected_date: selected_date }])
    SELECT users.*, user_service_jobs.*, service_jobs.*
    FROM users
    LEFT OUTER JOIN user_service_jobs ON users.id = user_service_jobs.user_id
    LEFT OUTER JOIN service_jobs ON user_service_jobs.service_job_id = service_jobs.id
    WHERE user_service_jobs.date = :selected_date
      AND users.role = 'technician'
    ORDER BY users.name ASC, user_service_jobs.start_time;
  SQL
}


  pg_search_scope :search_by_name,
                  against: [:name],
                  using: {
                    tsearch: { prefix: true, dictionary: 'english' }
                  }
end
