class CommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_for "comments_#{params[:record_type]}_#{params[:record_id]}"
  end
end
