class CustomersController < ApplicationController
  before_action :set_customer_from_params, only: %i[show edit update destroy]
  before_action :set_all_regions, only: %i[edit update new create]

  def new
    @customer = Customer.new
    @customer.build_point_of_contact
  end

  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      flash[:notice] = 'Customer created'
      redirect_to admin_customer_path(@customer)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show; end

  def index
    @pagy, @customers = pagy(Customer.all)
  end

  def edit
    @customer.build_point_of_contact
  end

  def update
    if @customer.update(customer_params)
      flash[:notice] = 'Customer updated'
      redirect_to admin_customer_path(@customer)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    return unless @customer.discard

    flash[:notice] = 'Customer removed'
    redirect_to admin_customers_path
  end

  private

  def customer_params
    params.require(:customer).permit(
      :name, :phone_number, :email, :address, :city, :state, :zipcode, :region_id,
      point_of_contact_attributes: %i[name phone_number email]
    )
  end

  def set_customer_from_params
    @customer = Customer.find(params[:id])
  end

  def set_all_regions
    @regions = Region.all
  end
end
