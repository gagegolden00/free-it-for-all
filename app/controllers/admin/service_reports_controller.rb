class Admin::ServiceReportsController < ApplicationController

  def new

  end

  def create

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
    params.require(:service_report).permit(:service_report_number, :warranty, :equipment_model, :equipment_serial, :mischarge, :total_charge, :employee_signature, :customer_signature, :service_job_id)
  end

end
