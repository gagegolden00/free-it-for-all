class UsersController < ApplicationController
  layout 'application_full'
  include UsersHelper
  include StateListHelper

  before_action :set_user_from_params, only: %i[show edit update destroy]

  def new
    @user = User.new
    authorize @user
  end

  def create
    @user = User.new(user_params)
    authorize @user
    if @user.save
      flash[:notice] = "User created successfully"
      redirect_to service_jobs_path
    end
  end

  def index
    if params[:user_search] && !params[:user_search].empty?
      @users = User.search_by_name(params[:user_search]).reorder(nil).order(get_collection_order)
    else
      @users = User.all.order(get_collection_order)
    end
    authorize @users
  end

  def show
    authorize @user
  end

  def edit
    authorize @user
  end

  def update
    authorize @user
    if @user.update(user_params)
      flash[:notice] = "User created updated"
      redirect_to service_jobs_path
    end
  end

  def destroy
    authorize @user
    return unless @user.discard
    flash[:notice] = "User deleted successfully"
    redirect_to service_jobs_path
  end

  private

  def user_params
    params.require(:user).permit(
      :role,
      :name,
      :home_phone,
      :work_phone,
      :carrier,
      :address,
      :city,
      :state,
      :zip_code,
      :hire_date,
      :email,
      :password
    )
  end

  def get_collection_order
    case params[:sort_by]
    when 'name asc'
      'name asc'
    when 'name desc'
      'name desc'
    else
      'name asc'
    end
  end

  def set_user_from_params
    @user = User.find(params[:id])
  end

end
