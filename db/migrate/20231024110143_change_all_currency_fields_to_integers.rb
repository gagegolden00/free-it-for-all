class ChangeAllCurrencyFieldsToIntegers < ActiveRecord::Migration[7.0]
  def change
    change_column :service_jobs, :contract_amount, :integer
  end
end
