class UpdateSignaturesToTextColumns < ActiveRecord::Migration[7.0]
  def change
    change_column :service_reports, :employee_signature, :text
    change_column :service_reports, :customer_signature, :text
  end
end
