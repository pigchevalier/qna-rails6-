class CommentsController < ApplicationController
  include ResourceFinder

  before_action :authenticate_user!

  after_action :publish_comment, only: [:create]

  def create
    @obj = parentable
    @comment = current_user.comments.build(comments_params)
    @comment.save
  end

  private

  def comments_params
    {body: params[:body], commenteable_id: @obj.id, commenteable_type: @obj.class}
  end

  def publish_comment
    return if @comment.errors.any?
    data = {commentable: @comment.commenteable, comment: @comment, class: @comment.commenteable.class.to_s}
    @comment.commenteable.class == Answer ? id = @comment.commenteable.question.id : id = @comment.commenteable.id
    ActionCable.server.broadcast "comments#{id}", data
  end
end
