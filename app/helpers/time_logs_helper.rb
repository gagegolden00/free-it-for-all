module TimeLogsHelper

  def calculate_total_minutes(hours:, minutes:)
    total_minutes = hours.to_i * 60 + minutes.to_i
    total_minutes.to_s
  end

end
