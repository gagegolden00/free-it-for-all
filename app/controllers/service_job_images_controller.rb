class ServiceJobImagesController < ApplicationController
  layout 'application_full'
  include ServiceJobImagesHelper

  before_action :set_service_job

  def create
    @service_job_image = ServiceJobImage.new(service_job_image_params)
    authorize @service_job_image

    @service_job_images = @service_job.service_job_images
    @service_job_image.user = current_user

    if @service_job_image.save
      redirect_to service_job_images_path(@service_job), notice: 'Image was successfully uploaded.'
    else
      redirect_to service_job_images_path(@service_job), alert: @service_job_image.errors.full_messages
    end

  end

  def index
    @service_job_images = @service_job.service_job_images
    @service_job_image = ServiceJobImage.new
    authorize @service_job_images
  end

  def destroy
    @service_job_image = ServiceJobImage.find(params[:id])
    authorize @service_job_image
    if @service_job_image.discard
      redirect_to service_job_images_path(@service_job), notice: 'Image was successfully deleted.'
    else
      redirect_to service_job_images_path(@service_job), alert: 'Failed to delete image.'
    end
  end

  def show
    @service_job_image = ServiceJobImage.find(params[:id])
    authorize @service_job_image
  end

  private

  def set_service_job
    @service_job = ServiceJob.find(params[:service_job_id])
  end

  def service_job_image_params
    params.require(:service_job_image).permit(:description, :image, :service_job_id, :user_id)
  end
end
