class ServiceReportFilterMaterialsParamsService < ApplicationService
  def initialize(params)
    @params = params
  end

  def call
    @params[:service_report_materials_attributes] = @params[:service_report_materials_attributes].select do |_, service_report_material_object|
      quantity = service_report_material_object[:quantity].to_i
      if service_report_material_object[:id].present?
        true
      else
        quantity.positive?
      end
    end
    @params
  end
end
