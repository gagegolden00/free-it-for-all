class AddFkToTimeLogs < ActiveRecord::Migration[7.0]
  def change
    add_column :time_logs, :user_id, :bigint
    add_foreign_key :time_logs, :users, column: :user_id
  end
end
