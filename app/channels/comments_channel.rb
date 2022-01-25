class CommentsChannel < ApplicationCable::Channel
  def follow
    stream_from "comments#{params[:id]}"
  end
end
