class AddFkToServiceReports < ActiveRecord::Migration[7.0]
  def change
    add_column :service_reports, :user_id, :bigint
    add_foreign_key :service_reports, :users, column: :user_id
  end
end
