class TimeLog < ApplicationRecord
  belongs_to :service_report
  belongs_to :user

  validate :at_least_one_time_present
  validate :total_time_not_greater_than_one_day

  private

  def total_time_not_greater_than_one_day
    max_minutes = 24 * 60
    total_minutes = regular_minutes.to_i + overtime_minutes.to_i + double_time_minutes.to_i

    if total_minutes > max_minutes
      errors.add(:base, "Total time cannot exceed 24 hours.")
    end
  end

  def at_least_one_time_present
    if regular_minutes.blank? && overtime_minutes.blank? && double_time_minutes.blank?
      errors.add(:base, "At least one time attribute must be present.")
    end
  end

end
