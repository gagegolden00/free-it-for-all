class ServiceJob < ApplicationRecord

  enum status: { pending: 'Pending', not_started: 'Not started', in_progress: 'In progress', on_hold: 'On hold', completed: 'Completed' }

  belongs_to :work_site, required: false
  belongs_to :customer
  has_many :service_reports
  has_many :user_service_jobs
  has_many :users, through: :user_service_jobs

  accepts_nested_attributes_for :customer, reject_if: :name_and_customer_id_blank?
  accepts_nested_attributes_for :work_site, reject_if: :name_blank?

  before_discard -> { discard_necessary_associated_record(work_site) }

  validates :job_number, presence: true, uniqueness: true

  def active_users
    user_service_jobs.where(discarded_at: nil).map(&:user)
  end

  private

  def name_and_customer_id_blank?(attributes)
    result = attributes['name'].blank? && attributes['customer_id'].blank?
    result
  end

  def name_blank?(attributes)
    result = attributes['name'].blank?
    result
  end

end
