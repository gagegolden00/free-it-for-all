module ServiceJobStatusListHelper
  def self.service_job_statuses
    [
      "Open",
      "Assigned",
      "In Progress",
      "On Hold",
      "Waiting on Parts",
      "Completed"
    ]
  end
end

