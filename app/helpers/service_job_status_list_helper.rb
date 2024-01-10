module ServiceJobStatusListHelper
  def self.service_job_statuses
    [
      "Open",
      "Assigned",
      "In progress",
      "On hold",
      "Waiting on parts",
      "Completed"
    ]
  end
end

