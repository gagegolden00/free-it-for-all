namespace :populate_db do
  desc "Create service reports materials"
  task create_service_report_materials: :environment do

  until ServiceReportMaterial.count == 100 do
    # All random values
    random_service_report_id = rand(1..ServiceJob.count)
    random_material_id = rand(1..Material.count)
    random_quanity = rand(1..200)
    random_individual_cost = rand(1..500_000)

    unless ServiceReportMaterial.exists?(service_report_id: random_service_report_id, material_id: random_material_id)
      ServiceReportMaterial.create!(
        service_report_id: random_service_report_id,
        material_id: random_material_id,
        quantity: random_quanity,
        pre_tax_total: random_quanity * random_individual_cost # Tax??
      )
      end
    end
  end
end

