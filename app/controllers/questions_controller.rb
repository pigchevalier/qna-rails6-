class QuestionsController < ApplicationController
  helper_method :question
  helper_method :answer
  helper_method :answers

  before_action :authenticate_user!, except: [:index, :show]

  def index
    @questions = Question.all
  end
  
  def show; end

  def new; end

  def create
    @question = current_user.questions.build(questions_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created'
    else
      render :new
    end
  end

  def destroy
    if current_user.author_of?(question)
      question.destroy
      redirect_to questions_path, notice: 'Your question successfully deleted'
    else
      redirect_to question, alert: "You are not author of this question"
    end
  end

  private

  def question
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end

  def questions_params
    params.require(:question).permit(:title, :body)
  end

  def answer
    @answer ||= Answer.new
  end

  def answers
    @answers ||= question.answers
  end
end
