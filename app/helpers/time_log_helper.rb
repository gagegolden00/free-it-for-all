module TimeLogHelper

  def get_total_hours(time)
    hours = time / 60 if time
    hours
  end

  def get_total_minutes(time)
    minutes = time % 60 if time
    minutes
  end

end
