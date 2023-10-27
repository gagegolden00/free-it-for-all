class Admin::ServiceReportsController < ApplicationController
  
  def new
    @service_report = ServiceReport.new
    @materials = Material.kept
  end

  def create
    filtered_params = service_report_params
    filtered_params[:service_report_materials_attributes] = filtered_params[:service_report_materials_attributes].select do |_, attributes|
      attributes[:quantity].to_i > 0
    end
    @service_report = ServiceReport.create(filtered_params)
  end

  def show

  end

  def index

  end

  def edit

  end

  def update

  end

  def destroy

  end

  private

  def set_service_report_from_params
    @service_report = ServiceReport.find(params[:id])
  end

  def service_report_params
    params.require(:service_report).permit(
      :service_report_number,
      :warranty,
      :equipment_model,
      :equipment_serial,
      :mischarge,
      :total_charge,
      :employee_signature,
      :customer_signature,
      :description,
      :service_job_id,
      service_report_materials_attributes: [:material_id, :quantity, :_destroy])
  end

end
