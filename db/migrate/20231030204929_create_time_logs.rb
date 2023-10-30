class CreateTimeLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :time_logs do |t|

      t.timestamps
    end
  end
end
