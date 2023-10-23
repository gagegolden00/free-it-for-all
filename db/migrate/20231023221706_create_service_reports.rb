class CreateServiceReports < ActiveRecord::Migration[7.0]
  def change
    create_table :service_reports do |t|

      t.timestamps
    end
  end
end
