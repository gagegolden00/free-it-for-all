class ServiceJobImagesController < ApplicationController

  before_action :set_service_job
  layout 'application_full'
  include ServiceJobImagesHelper

  before_action :set_service_job

  def create
    image = images_params[:service_job_image]

    if @service_job.images.attach(image)
      redirect_to service_job_images_path(@service_job), notice: 'Image was successfully uploaded.'
    else
      redirect_to new_service_job_image_path(@service_job), alert: 'Failed to upload image.'
    end
  end

  def index
    @images = @service_job.images
  end

  def destroy
    image = @service_job.images.find(params[:id])

    if image.purge
      redirect_to service_job_images_path(@service_job), notice: 'Image was successfully deleted.'
    else
      redirect_to service_job_image_path(@service_job, image), alert: 'Failed to delete image.'
    end
  end

  private

  def set_service_job
    @service_job = ServiceJob.find(params[:service_job_id])
  end

  def images_params
    params.require(:attachment).permit(:service_job_image)
  end
end
