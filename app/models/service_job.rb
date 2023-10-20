class ServiceJob < ApplicationRecord

  belongs_to :work_site, required: false
  belongs_to :customer

  validates :job_number, presence: true, uniqueness: true

  accepts_nested_attributes_for :customer, reject_if: :name_and_customer_id_blank?
  accepts_nested_attributes_for :work_site, reject_if: :name_blank?

  before_discard -> { discard_necessary_associated_record(work_site) }

  enum status: { pending: 'Pending', not_started: 'Not started', in_progress: 'In progress', on_hold: 'On hold', completed: 'Completed' }

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
