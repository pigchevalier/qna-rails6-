class QuestionsController < ApplicationController
  helper_method :question
  helper_method :answer
  helper_method :answers

  before_action :authenticate_user!, except: [:index, :show]

  after_action :publish_question, only: [:create]

  authorize_resource

  def index
    @questions = Question.all
  end
  
  def show; end

  def new
    question.links.new
    question.rewards.new
  end

  def create
    @question = current_user.questions.build(questions_params)

    if @question.save
      @sub = @question.subs.build
      @sub.user = current_user
      @sub.save
      redirect_to @question, notice: 'Your question successfully created'
    else
      render :new
    end
  end

  def update
    question.update(questions_params)
    @questions = Question.all
  end

  def destroy
    if can?(:destroy, question)
      question.destroy
    end
    @questions = Question.all   
  end

  def set_best_answer
    question.set_best_answer(params[:best_answer_id], current_user)     
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  def questions_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:name, :url], rewards_attributes: [:name, :image])
  end

  def answer
    @answer ||= Answer.new
  end

  def answers
    @answers ||= question.answers
  end

  def publish_question
    return if @question.errors.any?
    data = {question: @question, links: @question.links, rewards: @question.rewards, rating: @question.rating}
    ActionCable.server.broadcast 'questions', data
  end
end
