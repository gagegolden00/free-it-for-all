class PurchaseOrder < ApplicationRecord
  belongs_to :service_report
  before_save :calculate_total_price

  validates :purchase_order_number, presence: true
  validates :description, presence: true
  validates :service_report_id, presence: true

  def calculate_total_price
    self.total_price = price * quantity
  end
end
