class CustomersController < ApplicationController
  before_action :set_customer_from_params, only: [:show, :edit, :update, :destroy]
  before_action :set_all_regions, only: [:edit, :update, :new, :create]

  def new
    @customer = Customer.new
    @customer.build_point_of_contact
  end

  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      flash[:notice] = "Customer created"
      redirect_to @customer
    else
      puts @customer.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end


  def show;end

  def index
    @customers = Customer.all
  end

  def edit
    @customer.build_point_of_contact
  end

  def update
    if @customer.update(customer_params)
      puts "UPDATED"
      flash[:notice] = "Customer updated"
      redirect_to @customer
    else
      puts "DID NOT UPDATE"
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

  def set_all_regions
    @regions = Region.all
  end

end
