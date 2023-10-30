namespace :populate_db do
  desc "Create materials"
  task create_materials: :environment do

    # We can set this up with a list of mech cool's initial materials and run this for them to "seed"
    # for them initially. We should allow CRUD on materials.
    initial_materials = {
      chl_tube: rand(100..1_000_000),
      flue_tube: rand(100..1_000_000),
      crane: rand(100..1_000_000),
      lift_equipment: rand(100..1_000_000),
      a_frame: rand(100..1_000_000),
      torch: rand(100..1_000_000),
      solder: rand(100..1_000_000),
      nitrogen: rand(100..1_000_000),
      acetylene: rand(100..1_000_000),
      oxygen: rand(100..1_000_000),
      welder: rand(100..1_000_000),
      water_htr: rand(100..1_000_000),
      vb_analysis: rand(100..1_000_000),
      laser_align: rand(100..1_000_000),
      bas_comp: rand(100..1_000_000),
      pwr_washer: rand(100..1_000_000),
      lp_recovery: rand(100..1_000_000),
      hp_recovery: rand(100..1_000_000),
      ref_recovery: rand(100..1_000_000),
      ref_disposal: rand(100..1_000_000),
      electrical: rand(100..1_000_000)
  }


    initial_materials.each do |key, value|
      Material.create!(
        name: key,
        price: value
    )
    
    end

  end
end
