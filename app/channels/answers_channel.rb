class AnswersChannel < ApplicationCable::Channel
  def follow
    stream_from "answers#{params[:id]}"
  end
end