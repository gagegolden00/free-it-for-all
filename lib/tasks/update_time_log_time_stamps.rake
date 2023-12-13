namespace :populate_db do
  desc 'Update timelogs for accurate time sheets'
  task update_time_log_time_stamps: :environment do

    def update_timestamps
      start_date = Time.new(2023, 8, 1, 9, 0, 0)
      end_date = Time.new(2023, 12, 13, 21, 0, 0)
      number_of_reports = ServiceReport.count
      timestamps = (start_date..end_date).step((end_date - start_date) / number_of_reports).to_a

      ServiceReport.all.each_with_index do |service_report, index|
        timestamp = Time.at(timestamps[index])
        if service_report.time_log

          puts "Updating TimeLog ID #{service_report.time_log.id} with timestamp #{timestamp}"

          service_report.time_log.update!(created_at: timestamp)

        end
      end
    end

    update_timestamps

  end
end
