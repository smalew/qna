class RegardsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def index
    @regards = current_user.regards
  end
end
