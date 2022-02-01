class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource
  
  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    render json: question
  end

  def create
    @question = current_resource_owner.questions.build(questions_params)
    @question.save
    render json: question
  end

  def update
    question.update(questions_params)
    render json: question
  end

  def destroy
    if can?(:destroy, question)
      question.destroy
    end
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer   
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  def questions_params
    params.require(:question).permit(:title, :body, links_attributes: [:name, :url], rewards_attributes: [:name, :image])
  end
end
