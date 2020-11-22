# frozen_string_literal: true

class LinksController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  authorize_resource

  def destroy
    if can?(:destroy, link)
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
