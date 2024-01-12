class CustomersController < ApplicationController
  layout 'application_full'
  include ServiceJobStatusListHelper
  include StateListHelper

  before_action :set_customer_from_params, only: %i[show edit update destroy]
  before_action :set_all_regions, only: %i[edit update new create]
  before_action :authorize_access_in_customers_controller, only: %i[show edit update destroy]

  def new
    @states = us_states
    @customer = Customer.new
    @point_of_contact = @customer.build_point_of_contact
    authorize @customer
  end

  def create
    @customer = Customer.new(customer_params)
    @point_of_contact = @customer.point_of_contact
    authorize @customer
    if @customer.save
      flash[:notice] = 'Customer created'
      redirect_to customer_path(@customer)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    if params[:filter_by].present?
      @customer_service_jobs = @customer.service_jobs.includes(:work_site).where(status: get_status_filters)
    else
      @customer_service_jobs = @customer.service_jobs.includes(:work_site)
    end
  end

  def index
    @pagy, @customers = if search_present_and_not_empty_and_no_sort_by?
                          pagy(Customer.kept.search_by_customer_name_or_worksite_name(params[:customer_search]).order(get_collection_order))

                        elsif search_present_and_not_empty? && sort_by_present_and_not_empty?
                          pagy(Customer.search_by_customer_name_or_worksite_name(params[:customer_search]).reorder(nil).order(get_collection_order))

                        elsif no_search_and_sort_by_present_and_not_empty?
                          pagy(Customer.reorder(nil).order(get_collection_order))

                        else
                          pagy(Customer.order(get_collection_order))
                        end

    authorize @customers
  end

  def edit
    @states = us_states
    @customer.point_of_contact.nil? ? @point_of_contact = @customer.build_point_of_contact : @point_of_contact = @customer.point_of_contact
    authorize @point_of_contact
  end

  def update
    if @customer.update(customer_params)
      flash[:notice] = 'Customer updated'
      redirect_to customer_path(@customer)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    return unless @customer.discard
      flash[:notice] = 'Customer removed'
      redirect_to customers_path
  end

  private

  def authorize_access_in_customers_controller
    authorize @customer
  end

  def customer_params
    params.require(:customer).permit(
      :name, :phone_number, :email, :address, :city, :state, :zip_code, :region_id,
      point_of_contact_attributes: %i[name phone_number email]
    )
  end

  def search_present_and_not_empty?
    params[:customer_search].present? && !params[:customer_search].empty?
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

  def set_customer_from_params
    @customer = Customer.find(params[:id])
  end

  def get_collection_order
    case params[:sort_by]
    when 'name asc'
      'name asc'
    when 'name desc'
      'name desc'
    end
  end

  def get_status_filters
    case params[:filter_by]
    when 'Open'
      'Open'
    when 'Assigned'
      'Assigned'
    when 'In Progress'
      'In progress'
    when 'On Hold'
      'On hold'
    when 'Waiting on Parts'
      'Waiting on parts'
    when 'Completed'
      'Completed'
    else
      [ 'Open', 'Assigned', 'In progress', 'On hold', 'Waiting on parts', 'Completed' ]
    end
  end

  def set_all_regions
    @regions = Region.kept
  end
end
