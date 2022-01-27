class AnswersController < ApplicationController
  helper_method :answer
  helper_method :question

  before_action :authenticate_user!

  after_action :publish_answer, only: [:create]

  authorize_resource

  def create 
    @answer = question.answers.build(answers_params)
    @answer.user = current_user

    @answer.save
    question
  end

  def update
    answer.update(answers_params)
    @question = answer.question
  end

  def destroy
    @question = answer.question
    if can?(:destroy, answer)
      answer.destroy
    end
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new
  end

  def question
    @question = Question.find(params[:question_id])
  end 

  def answers_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end

  def publish_answer
    return if @answer.errors.any?
    data = {question: @question, answer: @answer, links: @answer.links, rating: @answer.rating}
    ActionCable.server.broadcast "answers#{@answer.question_id}", data
  end
end
