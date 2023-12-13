class ApplicationController < ActionController::Base
  include Pundit::Authorization
  include Pagy::Backend
  before_action :authenticate_user!
  after_action :verify_authorized

end
