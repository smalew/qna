# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :prepare_gon_current_user

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to questions_url, alert: exception.message
  end

  check_authorization unless: :devise_controller?

  private

  def prepare_gon_current_user
    gon.current_user = current_user
  end
end
