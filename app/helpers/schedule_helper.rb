module ScheduleHelper

  def self.get_grid_col_value(time)
    unless time.nil?
      hours = time.strftime('%H').to_i
      minutes = time.strftime('%M').to_i
      grid_col_start_value = ((hours * 4) + (minutes / 15) + 2).to_s
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
