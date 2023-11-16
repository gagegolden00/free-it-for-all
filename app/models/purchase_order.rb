class PurchaseOrder < ApplicationRecord
  belongs_to :service_report
  before_save :calculate_total_price

  def calculate_total_price
    self.total_price = price * quantity
  end
end
