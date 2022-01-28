class ApplicationController < ActionController::Base
  before_action :gon_current_user, unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  check_authorization unless: :devise_controller?

  private

  def gon_current_user
    current_user ? gon.push({current_user: current_user}) : gon.push({current_user: {id: nil}})
  end
end
