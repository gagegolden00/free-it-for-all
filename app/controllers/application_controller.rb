class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include Pagy::Backend
  before_action :authenticate_user!
  # after_action :verify_authorized, unless: :skip_verify_authorized?
  # need to implement policy for serivce job images

  private

  def skip_verify_authorized?
    is_a?(DeviseController)
  end
end
