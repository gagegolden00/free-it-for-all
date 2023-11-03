class ServiceReportsController < ApplicationController
  before_action :set_service_job
  before_action :set_service_report, only: %i[show edit update destroy]
  before_action :set_materials, only: %i[new create edit update]
  before_action :set_existing_service_report_materials, only: %i[edit update]

  def new
    @service_report = ServiceReport.new
  end

  def create
    filtered_params = filter_params(service_report_params)
    @service_report = ServiceReport.create!(filtered_params)
    @purchase_order.purchase_order_number = @service_job.job_number + "-REPORT-#{@service_job.service_reports.count + 1}"
    if @service_report.save
      flash[:notice] = "Service report created"
      redirect_to service_job_service_report_path(@service_job, @service_report)
    else
      render :new
    end
  end

  def show
    @service_report_materials = ServiceReport.materials_used(@service_report)
  end

  def index
    @service_reports = @service_job.service_reports.kept
  end

  def edit
    @service_report.service_report_materials.build
  end

  def update
    filtered_params = filter_params(service_report_params)
    if @service_report.update(filtered_params)
      flash[:notice] = "Service report updated"
      redirect_to service_job_service_report_path(@service_job, @service_report)
    else
      render :edit
    end
  end

  def destroy
    if @service_report.discard
      flash[:notice] = "Report deleted"
      redirect_to service_job_service_reports_path(@service_job)
    end

  end

  private

  def set_service_job
    @service_job = ServiceJob.find(params[:service_job_id])
  end

  def set_service_report
    @service_report = @service_job.service_reports.find(params[:id])
  end

  def set_materials
    @materials = Material.kept.includes(:service_report_materials)
  end

  def set_existing_service_report_materials
    @existing_materials_by_id = @service_report.service_report_materials.index_by(&:material_id) if @service_report
  end


  def filter_params(params)
    params[:service_report_materials_attributes] = params[:service_report_materials_attributes].select do |_, service_report_material_object|
      quantity = service_report_material_object[:quantity].to_i
      if service_report_material_object[:id].present?
        true
      else
        quantity.positive?
      end
    end
    params
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
      service_report_materials_attributes: %i[id material_id quantity _destroy]
    )
  end
end

