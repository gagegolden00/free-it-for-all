class CustomersController < ApplicationController
  before_action :set_customer_from_params, only: [:show, :edit, :update, :destroy]

  def new
    @customer = Customer.new
    @regions = Region.all
    @customer.build_point_of_contact
  end

  def create
    @regions = Region.all
    @customer = Customer.new(customer_params)
    if @customer.save
      flash[:notice] = "Customer created"
      redirect_to @customer
    else
      render :new, status: :unprocessable_entity
    end
  end


  def show;end

  def index
    @customers = Customer.all
  end

  def edit
    @regions = Region.all
    @customer.build_point_of_contact
  end

  def update
    if @customer.update!(customer_params)
      flash[:notice] = "Customer updated"
      redirect_to @customer
    else
      flash[:alert] = "Update failed"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @customer.discard
      flash[:notice] = "Customer removed"
      redirect_to customers_path
    end
  end

  private

  def customer_params
    params.require(:customer).permit(
      :name, :phone_number, :email, :address, :city, :state, :zipcode, :region_id,
      point_of_contact_attributes: [:name, :phone_number, :email])
  end

  def set_customer_from_params
    @customer = Customer.find(params[:id])
  end

end
