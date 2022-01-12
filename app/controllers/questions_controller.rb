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

  def update
    if current_user.author_of?(question)
      question.update(questions_params)
      @questions = Question.all
    end
  end

  def destroy
    if current_user.author_of?(question)
      question.destroy
      @questions = Question.all
    end
  end

  def set_best_answer
    if current_user.author_of?(question)
      question.best_answer = Answer.find(params[:best_answer_id])
      question.save
    end
  end

  def delete_file_attachment
    if current_user.author_of?(question)
      @file = ActiveStorage::Attachment.find(params[:file_id])
      @file.purge
    end
    @questions = Question.all
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  def questions_params
    params.require(:question).permit(:title, :body, files: [])
  end

  def answer
    @answer ||= Answer.new
  end

  def answers
    @answers ||= question.answers
  end
end
