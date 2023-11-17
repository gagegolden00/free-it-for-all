class ServiceJobsController < ApplicationController
  layout 'application_full'

  include StateListHelper
  include ServiceJobStatusListHelper

  before_action :set_service_job_from_params, only: %i[show edit update destroy]
  before_action :authorize_access_in_service_jobs_controller, only: %i[show edit update destroy]
  before_action :set_all_customers, only: %i[new create edit update]

  def new
    @service_job = ServiceJob.new
    authorize @service_job
    @service_job.build_customer
    @service_job.customer.build_point_of_contact
    @service_job.build_work_site
  end

  def create
    @customers = Customer.kept
    @service_job = ServiceJob.new(permitted_params)
    if @service_job.save
      flash[:notice] = 'Service job created'
      redirect_to service_job_path(@service_job)
    else
      render :new
    end
  end


    def index
      service_job_search_scope = policy_scope(ServiceJob).search_by_job_number_or_customer_name(params[:service_job_search]).distinct
      @pagy, @service_jobs = if search_present_and_not_empty_and_no_sort_by?
                               pagy(service_job_search_scope.filter_by_status(get_status_filters).order(created_at: :asc))

                             elsif search_present_and_not_empty? && sort_by_present_and_not_empty?
                               pagy(service_job_search_scope.filter_by_status(get_status_filters).reorder(nil).order(get_sorting_order))

                             elsif no_search_and_sort_by_present_and_not_empty?
                               pagy(policy_scope(ServiceJob).filter_by_status(get_status_filters).reorder(nil).order(get_sorting_order))

                             else
                               pagy(policy_scope(ServiceJob).filter_by_status(get_status_filters).order(created_at: :asc))
                             end

      authorize @service_jobs
    end


  def show
    @technician_users = User.only_technicians
    @active_users = @service_job.active_users
  end

  def edit
    @service_job.build_customer
    @service_job.customer.build_point_of_contact
    @service_job.build_work_site
  end

  def update
    if @service_job.update(permitted_params)
      redirect_to service_job_path(@service_job)
    else
      render :edit
    end
  end

  def destroy
    return unless @service_job.discard

    flash[:notice] = 'Service Job deleted'
    redirect_to service_jobs_path
  end

  private

  def authorize_access_in_service_jobs_controller
    authorize @service_job
  end

  def set_service_job_from_params
    @service_job = ServiceJob.find(params[:id])
  end

  def set_all_customers
    @customers = Customer.kept
  end

  def permitted_params
    params.require(:service_job).permit(
      :job_number,
      :status,
      :description,
      :contract_amount,
      :work_type,
      :customer_id,
      customer_attributes: [
        :name,
        :phone_number,
        :email,
        :address,
        :city,
        :state,
        :zip_code,
        { point_of_contact_attributes: %i[name phone_number email] }
      ],
      work_site_attributes: %i[name address city state zip_code email phone_number]
    )
  end

  def search_present_and_not_empty?
    params[:service_job_search].present? && !params[:service_job_search].empty?
  end

  def sort_by_present_and_not_empty?
    params[:sort_by].present? && !params[:sort_by].empty?
  end

  def no_search_and_sort_by_present_and_not_empty?
    !search_present_and_not_empty? && sort_by_present_and_not_empty?
  end

  def search_present_and_not_empty_and_no_sort_by?
    search_present_and_not_empty? && !sort_by_present_and_not_empty?
  end

  def get_sorting_order
    case params[:sort_by]

    when 'job_number asc'
      'job_number asc'
    when 'job_number desc'
      'job_number desc'
    when 'created_at asc'
      'created_at asc'
    when 'created_at desc'
      'created_at desc'
    end
  end

  def get_status_filters
    return unless params[:filter_by] && !params[:filter_by].empty?

    status_filters = []
    status_filters << 'Open' if params[:filter_by].include?('Open')
    status_filters << 'Assigned' if params[:filter_by].include?('Assigned')
    status_filters << 'In progress' if params[:filter_by].include?('In Progress')
    status_filters << 'On hold' if params[:filter_by].include?('On Hold')
    status_filters << 'Waiting on parts' if params[:filter_by].include?('Waiting on Parts')
    status_filters << 'Completed' if params[:filter_by].include?('Completed')
    status_filters
  end

  def service_job_index_params
    params.permit(:sort_by)
  end
end
