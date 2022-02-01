class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource

  def show
    render json: answer
  end

  def create 
    @answer = question.answers.build(answers_params)
    @answer.user = current_resource_owner
    @answer.save
    render json: answer
  end

  def update
    answer.update(answers_params)
    @question = answer.question
    render json: answer
  end

  def destroy
    @question = answer.question
    if can?(:destroy, answer)
      answer.destroy
    end
    render json: @question
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new
  end

  def question
    @question = Question.find(params[:question_id])
  end

  def answers_params
    params.require(:answer).permit(:body, links_attributes: [:name, :url])
  end
end
