class ServiceReportsController < ApplicationController
  include TimeLogHelper

  layout 'application_full'

  before_action :set_service_job
  before_action :set_service_report, only: %i[show edit update destroy]
  before_action :set_materials, only: %i[new create edit update]
  before_action :set_purchase_orders, only: %i[edit update show]

  def new
    @service_report = ServiceReport.new
    @service_report.build_time_log
    authorize @service_report
  end

  def create
    time_converted_params = ServiceReportTimeConverterService.call(service_report_params)
    filtered_params = filter_material_params(time_converted_params)
    @service_report = ServiceReport.create!(filtered_params)
    authorize @service_report
    if @service_report.save
      flash[:notice] = 'Service report created'
      redirect_to service_job_service_report_path(@service_job, @service_report)
    else
      render :new
    end
  end

  def show
    @service_report_materials = ServiceReport.materials_used(@service_report)
    @time_log = @service_report.time_log
    @service_report_user = User.find(@service_report.user_id)
    authorize @service_report
  end

  def index
    @service_reports = @service_job.service_reports.kept
    authorize @service_reports
  end

  def edit
    @service_report.service_report_materials.build
    @time_log = @service_report.time_log
    @service_report.build_time_log unless @service_report.time_log
    @existing_materials_by_id = @service_report.service_report_materials.index_by(&:material_id) if @service_report
    authorize @service_report
  end

  def update
    @existing_materials_by_id = @service_report.service_report_materials.index_by(&:material_id) if @service_report
    time_converted_params = ServiceReportTimeConverterService.call(service_report_params)
    filtered_params = filter_material_params(time_converted_params)
    authorize @service_report
    if @service_report.update(filtered_params)
      flash[:notice] = 'Service report updated'
      redirect_to service_job_service_report_path(@service_job, @service_report)
    else
      render :edit
    end
  end

  def destroy
    authorize @service_report
    return unless @service_report.discard
    
    flash[:notice] = 'Service report deleted'
    redirect_to service_job_service_reports_path(@service_job)
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

  def set_purchase_orders
    @purchase_orders = @service_report.purchase_orders
  end

  def filter_material_params(params)
    if params[:service_report_materials_attributes].present?
    params[:service_report_materials_attributes] = params[:service_report_materials_attributes].select do |_, service_report_material_object|
      quantity = service_report_material_object[:quantity].to_i
      if service_report_material_object[:id].present?
        true
      else
        quantity.positive?
      end
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
      :user_id,
      :regular_hours_input,
      :regular_minutes_input,
      :overtime_hours_input,
      :overtime_minutes_input,
      :double_time_hours_input,
      :double_time_minutes_input,
      service_report_materials_attributes: %i[id material_id quantity _destroy],
      time_log_attributes: %i[id user_id regular_minutes overtime_minutes double_time_minutes mileage remarks]
    )
  end
end
