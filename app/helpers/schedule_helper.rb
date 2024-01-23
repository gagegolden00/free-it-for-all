module ScheduleHelper

  def self.get_24_hr_grid_col_value(time)
    unless time.nil?
      hours = time.strftime('%H').to_i
      minutes = time.strftime('%M').to_i
      grid_col_value = ((hours * 4) + (minutes / 15)).to_i + 2
      grid_col_value.to_s
    end
  end

  def self.get_12_hr_grid_col_value(time)
    unless time.nil?
      hours = time.strftime('%H').to_i
      minutes = time.strftime('%M').to_i
      grid_col_value = ((hours * 4) + (minutes / 15)).to_i - 26

      if grid_col_value < 2
        grid_col_value = 3
      elsif grid_col_value > 54
        grid_col_value = 54
      end
      grid_col_value.to_s
    end
  end




  def self.color_list
    [
      'bg-gray-500',
      'bg-red-500',
      'bg-yellow-500',
      'bg-green-500',
      'bg-blue-500',
      'bg-indigo-500',
      'bg-purple-500',
      'bg-pink-500',
    ]
  end
end
