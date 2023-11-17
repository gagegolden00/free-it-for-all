class UpdateEnums < ActiveRecord::Migration[7.0]

  def up
    execute <<-SQL
    ALTER TYPE status RENAME TO service_job_status;
    ALTER TYPE service_job_status RENAME VALUE 'Pending' TO 'Open';
    ALTER TYPE service_job_status RENAME VALUE 'Not started' TO 'Assigned';
    ALTER TYPE service_job_status ADD VALUE 'Waiting on parts' AFTER 'Assigned';
    SQL
  end
end


