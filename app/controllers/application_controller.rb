class ApplicationController < ActionController::Base
  before_action :gon_current_user, unless: :devise_controller?

  private

  def gon_current_user
    current_user ? gon.push({current_user: current_user}) : gon.push({current_user: {id: nil}})
  end
end
