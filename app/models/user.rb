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

  scope :all_with_time_log_totals_in_time_period, ->(start_date, end_date, order) {
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




end
