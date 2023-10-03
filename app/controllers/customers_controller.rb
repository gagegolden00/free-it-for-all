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
      redirect_to @customer
    else
      render :new
    end
  end

  def customer_params
    params.require(:customer).permit(
      :name, :phone_number, :email, :address, :city, :state, :zipcode, :region_id,
      point_of_contact_attributes: [:name, :phone_number, :email])
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
    if @customer.update(customer_params)
      redirect_to @customer
    else
      render :edit
    end
  end

  def destroy
    if @customer.discard
      # redirect here
      puts "CUSTOMER DISCARDED"
    end
  end



  def set_customer_from_params
    @customer = Customer.find(params[:id])
  end

end
