class ApplicationController < ActionController::Base
  before_action :gon_current_user, unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render json: exception.message, status: :forbidden }
      format.js { render nothing: true, status: :forbidden }
      format.html { redirect_to root_url, alert: exception.message }
    end
  end

  check_authorization unless: :devise_controller?

  private

  def gon_current_user
    current_user ? gon.push({current_user: current_user}) : gon.push({current_user: {id: nil}})
  end
end
