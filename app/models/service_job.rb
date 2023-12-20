class ServiceJob < ApplicationRecord
  enum status: { open: 'Open', assigned: 'Assigned', in_progress: 'In progress', on_hold: 'On hold',
                 waiting_on_parts: 'Waiting on parts', completed: 'Completed' }

  belongs_to :work_site, required: false
  belongs_to :customer
  has_many :service_reports
  has_many :user_service_jobs
  has_many :users, through: :user_service_jobs
  has_many :purchase_orders, through: :service_reports
  has_many :service_job_images

  accepts_nested_attributes_for :customer, reject_if: :name_and_customer_id_blank?
  accepts_nested_attributes_for :work_site, reject_if: :name_blank?

  validates :job_number, presence: true, uniqueness: true

  pg_search_scope :search_by_job_number_or_customer_name,
                  against: [:job_number],
                  associated_against: {
                    customer: [:name]
                  },
                  using: {
                    tsearch: { dictionary: 'english', prefix: true},
                    trigram: {
                      threshold: 0.3,
                      word_similarity: true
                    }
                  }

  scope :filter_by_status, ->(status) { where(status: status) if status.present? }

  def active_users
    user_service_jobs.where(discarded_at: nil).map(&:user)
  end

  private

  def name_and_customer_id_blank?(attributes)
    attributes['name'].blank? && attributes['customer_id'].blank?
  end

  def name_blank?(attributes)
    attributes['name'].blank?
  end
end
