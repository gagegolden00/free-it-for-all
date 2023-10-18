class ServiceJob < ApplicationRecord
  belongs_to :work_site, required: false
  belongs_to :customer
  accepts_nested_attributes_for :customer
  accepts_nested_attributes_for :work_site
  enum status: { pending: 'Pending', not_started: 'Not started', in_progress: 'In progress', on_hold: 'On hold', completed: 'Completed' }
end
