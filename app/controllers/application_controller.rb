class ApplicationController < ActionController::Base
  before_action :prepare_gon_current_user

  private

  def prepare_gon_current_user
    gon.current_user = current_user
  end
end
