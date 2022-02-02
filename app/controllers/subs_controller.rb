class SubsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question

  authorize_resource

  def create
    @sub = @question.subs.build
    @sub.user = current_user
    @sub.save
  end

  def destroy 
    @sub = Sub.find(params[:id])   

    if can?(:destroy, @sub)
      @sub.destroy
    end
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end
end
