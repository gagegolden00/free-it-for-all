class ApplicationController < ActionController::Base
  include Pundit::Authorization
  # after_action :verify_authorized, except: :index
  # after_action :verify_policy_scoped, only: :index
end
