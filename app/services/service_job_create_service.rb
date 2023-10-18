class ServiceJobCreateService < ApplicationService
  def initialize(params)
    @params = params
  end

  def create_service_job
    ServiceJob.create!(decide_params)
  end

  private

  def decide_params
    case

    when @params[:customer_id].present? && @params[:worksite_id].present?
      base_params..permit!

    when !@params[:customer_id].present? && !@params[:worksite_id].present?
      base_params.require(:service_job).permit!.merge(customer_params)

    when !@params[:customer_id].present? && @params[:worksite_id].present?
      base_params.require(:service_job).permit!.merge(customer_params).except(:customer_params)

    when @params[:customer_id].present? && !@params[:worksite_id].present?
      base_params.require(:service_job).permit!.merge(customer_params).except(:worksite_params)

    when !@params[:customer_id].present? && !@params[:point_of_contact].present? && @params[:worksite_id].present?
      base_params.require(:service_job).permit!.merge(customer_params).merge(worksite_params)

    when @params[:customer_id].present? && @params[:point_of_contact].present? && !@params[:worksite_id].present?
      base_params.require(:service_job).permit!.merge(customer_params).merge(point_of_contact_params)

    when @params[:customer_id].present? && @params[:point_of_contact].present? && @params[:worksite_id].present?
      base_params.require(:service_job).permit!.merge(customer_params).merge(point_of_contact_params).merge(worksite_params)

    end
  end

  def service_job_params
    @params.require(:service_job).permit(:job_number, :status, :description, :contract_amount, :work_type)
  end

  def customer_params
    @params.require(:customer).permit(:name, :phone_number, :email, :address, :city, :state, :zipcode)
  end

  def worksite_params
    @params.require(:worksite).permit(:name, :address, :city, :state, :zipcode, :email, :phone_number)
  end

  def point_of_contact_params
    @params.require(:point_of_contact).permit(:name, :phone_number, :email)
  end
end
