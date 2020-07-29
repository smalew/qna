class RegardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @regards = current_user.regards
  end
end
