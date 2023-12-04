class PurchaseOrdersController < ApplicationController

  before_action :set_purchase_order_from_params, only: %i[show edit update destroy]
  before_action :set_service_job_from_params

  def new
    @purchase_order = PurchaseOrder.new
  end

  def create
    @purchase_order = PurchaseOrder.new(purchase_order_params)
    @purchase_order.purchase_order_number = @service_job.job_number + "-PO-#{@service_job.purchase_orders.count + 1}"
    authorize @purchase_order
    if @purchase_order.save
      flash[:notice] = "Purchase order created"
      redirect_to service_job_purchase_orders_path(@service_job)
    else
      render :new
    end
  end

  def show
    @service_report = ServiceReport.find(@purchase_order.service_report_id)
    authorize @purchase_order
  end

  def index
    @purchase_orders = policy_scope(@service_job.purchase_orders)
    authorize @purchase_orders
  end

  def edit;end

  def update
    authorize @purchase_order
    if @purchase_order.update(purchase_order_params)
      flash[:notice] = "Purchase order updated"
      redirect_to service_job_purchase_orders_path(@service_job)
    else
      render :edit
    end
  end

  def destroy
    authorize @purchase_order
    if @purchase_order.discard
      flash[:notice] = "Purchase order successfully deleted"
      redirect_to service_job_purchase_orders_path(@service_job)
    end
  end

  private

  def purchase_order_params
    params.require(:purchase_order).permit(:purchase_order_number, :vendor, :quantity, :description, :price, :total_price, :notes, :internal_notes, :service_report_id)
  end

  def set_purchase_order_from_params
    @purchase_order = PurchaseOrder.find(params[:id])
  end

  def set_service_job_from_params
    @service_job = ServiceJob.find(params[:service_job_id])
  end

end
