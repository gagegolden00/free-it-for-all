namespace :populate_db do
  desc 'Discard random record for testing discard'
  task discard_records: :environment do

    # Discard 10 random materials
    materials = Material.all
    10.times do
      material = materials.sample
      unless material.discarded?
        material.discard
        puts "Material discarded: id: #{material.id}, name: #{material.name} name: #{material.price}"
      end
    end

  end
end
