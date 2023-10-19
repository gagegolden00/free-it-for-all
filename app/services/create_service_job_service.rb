class CreateServiceJobService < ApplicationService
  attr_reader :params

  def initialize(params:)
    @params = params
  end

  def create
    ServiceJob.new(decide_params(@params))
  end

  private

  def decide_params(params)
    case
    when params[:service_job][:customer_id].present? && !params[:service_job][:work_site_id].present?
      params.require(:service_job).permit(
        :job_number,
        :status,
        :description,
        :contract_amount,
        :work_type,
        :customer_id
      )

    # when params[:service_job][:customer_attributes].present?
    #   params.require(:service_job).permit(
    #     :job_number,
    #     :status,
    #     :description,
    #     :contract_amount,
    #     :work_type,
    #     customer_attributes: [
    #       :name,
    #       :phone_number,
    #       :email,
    #       :address,
    #       :city,
    #       :state,
    #       :zip_code,
    #       point_of_contact_attributes: [:name, :phone_number, :email]
    #     ]
    #   )

    # when !params[:customer_id].present? && !params[:work_site_id].present?
    #   params.require(:service_job).permit(
    #     :job_number,
    #     :status,
    #     :description,
    #     :contract_amount,
    #     :work_type
    #   )

    # when !params[:customer_id].present? && params[:work_site_id].present?
    #   params.require(:service_job).permit(
    #     :job_number,
    #     :status,
    #     :description,
    #     :contract_amount,
    #     :work_type,
    #     work_site_attributes: [
    #       :name,
    #       :address,
    #       :city,
    #       :state,
    #       :zip_code,
    #       :email,
    #       :phone_number
    #     ]
    #   )

    # when params[:customer_id].present? && !params[:work_site_id].present?
    #   params.require(:service_job).permit(
    #     :job_number,
    #     :status,
    #     :description,
    #     :contract_amount,
    #     :work_type,
    #     customer_attributes: [
    #       :name,
    #       :phone_number,
    #       :email,
    #       :address,
    #       :city,
    #       :state,
    #       :zip_code
    #     ]
    #   )

    # when params[:customer_id].present? && params[:point_of_contact].present? && !params[:work_site_id].present?
    #   params.require(:service_job).permit(
    #     :job_number,
    #     :status,
    #     :description,
    #     :contract_amount,
    #     :work_type,
    #     customer_attributes: [
    #       :name,
    #       :phone_number,
    #       :email,
    #       :address,
    #       :city,
    #       :state,
    #       :zip_code,
    #       point_of_contact_attributes: [:name, :phone_number, :email]
    #     ]
    #   )
    end
  end
end
