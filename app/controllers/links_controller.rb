class LinksController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def destroy
    if current_user.author_of?(link.linkable)
      link.destroy
    else
      render 'questions/show'
    end
  end

  private

  def link
    @link ||= Link.find(params[:id])
  end
  helper_method :link
end
