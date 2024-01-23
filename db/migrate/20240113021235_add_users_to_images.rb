class AddUsersToImages < ActiveRecord::Migration[7.0]
  def change
    add_reference :service_job_images, :user, foreign_key: true
  end
end

