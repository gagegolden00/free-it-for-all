module TimeLogHelper

  def get_total_hours(time:)
    hours = time / 60
    hours
  end

  def get_total_minutes(time:)
    minutes = time % 60
    minutes
  end

end
