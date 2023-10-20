module StatusListHelper 
  def service_job_statuses
    [
      "Pending",
      "Not started",
      "In progress",
      "On hold",
      "Completed"
    ]
  end
end
