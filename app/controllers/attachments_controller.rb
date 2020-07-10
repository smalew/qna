class AttachmentsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def destroy
    if current_user.author_of?(attachment.record)
      attachment.purge
    else
      render 'questions/show'
    end
  end

  private

  def attachment
    @attachment ||= ActiveStorage::Attachment.find(params[:id])
  end
  helper_method :attachment
end
