class CreateServiceJobImages < ActiveRecord::Migration[7.0]
  def change
    create_table :service_job_images do |t|
      t.text :image_data
      t.text :description
      t.references :service_job
      t.timestamps
      t.timestamp :discarded_at
    end
  end
end
