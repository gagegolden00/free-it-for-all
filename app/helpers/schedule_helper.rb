module ScheduleHelper

  def self.get_grid_col_value(time)
    unless time.nil?
      hours = time.strftime('%H').to_i
      minutes = time.strftime('%M').to_i
      grid_col_start_value = ((hours * 4) + (minutes / 15) + 2).to_s
    else
      # this is probably not correct for the null values in respect to the UI 
      grid_col_start_value = '0'
    end
  end
end
