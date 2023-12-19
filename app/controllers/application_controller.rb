class ApplicationController < ActionController::Base

  include Pundit::Authorization
  include Pagy::Backend
  before_action :authenticate_user!
  after_action :verify_authorized, unless: :skip_verify_authorized?

  private

  def skip_verify_authorized?
    is_a?(DeviseController)
  end



end
