class CustomersController < ApplicationController
  layout 'application_full'

  before_action :set_customer_from_params, only: %i[show edit update destroy]
  before_action :set_all_regions, only: %i[edit update new create]
  before_action :authorize_access_in_customers_controller, only: %i[show edit update destroy]

  def new
    @customer = Customer.new
    @customer.build_point_of_contact
    authorize @customer
  end

  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      flash[:notice] = 'Customer created'
      redirect_to customer_path(@customer)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def index
    @pagy, @customers = pagy(Customer.kept)
    authorize @customers
  end

  def edit
    if @customer.point_of_contact.nil?
      @customer.build_point_of_contact
    end
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

  def set_customer_from_params
    @customer = Customer.find(params[:id])
  end

  def set_all_regions
    @regions = Region.kept
  end
end
