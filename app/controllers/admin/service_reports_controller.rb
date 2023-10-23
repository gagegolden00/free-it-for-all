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

  def service_report_params
    params.require(:service_job).permit()
  end

  def set_service_report_from_params
    @service_report = ServiceReport.find(params[:id])
  end
end
