class AnswersController < ApplicationController
  helper_method :answer
  helper_method :question

  before_action :authenticate_user!

  def create
    @answer = question.answers.build(answers_params)
    @answer.user = current_user

    if @answer.save
      redirect_to @answer.question, notice: 'Your answer successfully created'
    else
      question
      render 'questions/show'
    end
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
      redirect_to answer.question, notice: 'Your answer successfully deleted'
    else
      redirect_to answer.question, alert: "You are not author of this answer"
    end
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  def question
    @question = Question.find(params[:question_id])
  end 

  def answers_params
    params.require(:answer).permit(:body)
  end
end
