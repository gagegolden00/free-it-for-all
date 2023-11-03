class PurchaseOrdersController < ApplicationController

  #before_action :set_purchase_order_from_params, only: %i[show edit update destroy]
  #before_action :set_service_job_from_params

  def new
    @service_job = ServiceJob.find(params[:service_job_id])
    @purchase_order = PurchaseOrder.new
  end

  def create
    @service_job = ServiceJob.find(params[:service_job_id])
    @purchase_order = PurchaseOrder.new(purchase_order_params)
    @purchase_order.purchase_order_number = @service_job.job_number + "-PO #{@service_job.purchase_orders.count + 1}"
    if @purchase_order.save
      redirect_to
    else
      render :new
    end
  end

  def show
    @purchase_order = PurchaseOrder.find(params[:id])
  end

  def index
    @service_job = ServiceJob.find(params[:service_job_id])
    @purchase_orders = @service_job.purchase_orders
  end

  def edit;end

  def update
    if @purchase_order.update(purchase_order_params)
      redirect_to service_report_path(@service_report)
    else
      render :new
    end
  end

  def destroy
    if @purchase_order.discard
      flash[:notice] = "Purchase order successfully deleted"
      redirect_to service_report_purchase_order_path(@purchase_order)
    end
  end

  private

  def purchase_order_params
    params.require(:purchase_order).permit(:purchase_order_number, :quantity, :description, :price, :total_price, :notes, :internal_notes, :service_report_id)
  end

  def set_purchase_order_from_params
    @purchase_order = PurchaseOrder.find(params[:id])
  end

  def set_service_job_from_params
    @service_job = ServiceJob.find(params[:service_job_id])
  end

end
