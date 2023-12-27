class PagesController < ApplicationController

  def home
    render :layout => "application_full"
    @user = current_user
    authorize :pages, :home?
  end

end
