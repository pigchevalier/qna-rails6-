class AnswersController < ApplicationController
  helper_method :answer
  helper_method :question

  before_action :authenticate_user!

  def create
    @answer = question.answers.build(answers_params)
    @answer.user = current_user

    @answer.save
    question
  end

  def update
    if current_user.author_of?(answer)
      answer.update(answers_params)
      @question = answer.question
    end
  end

  def destroy
    if current_user.author_of?(answer)
      @question = answer.question
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
    params.require(:answer).permit(:body, files: [])
  end
end
