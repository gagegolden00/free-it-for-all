class Customer < ApplicationRecord
  has_one :point_of_contact, dependent: :destroy, required: false
  belongs_to :region, required: false
  has_many :service_jobs

  validates :name, presence: true

  accepts_nested_attributes_for :point_of_contact

  pg_search_scope :search_by_customer_name_or_worksite_name,
                  against: [:name],
                  using: {
                    tsearch: { prefix: true, dictionary: 'english' }
                  }

  private

end
