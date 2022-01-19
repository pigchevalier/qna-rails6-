class VotesController < ApplicationController
  include Serialized

  before_action :authenticate_user!

  def create
    obj_klass = params.dig(:vote, :voteable_type)
    if obj_klass == 'Answer'    
      obj = Answer.find(params.dig(:vote, :voteable_id))
    elsif obj_klass == 'Question'
      obj = Question.find(params.dig(:vote, :voteable_id))
    end
    if !current_user.author_of?(obj)
      @vote = current_user.votes.build(votes_params)
      respond_to do |format|
        if @vote.save
          format.json { render_json([obj.rating, @vote.id]) }
        else
          format.json { render_errors(@vote)}
        end
      end
    end
  end

  def destroy 
    @vote = Vote.find(params[:id])   
    
    if !current_user.author_of?(@vote.voteable) 
      obj = @vote.voteable
      respond_to do |format|
        if @vote.destroy
          format.json { render_json(obj.rating) }
        else
          format.json { render_errors(@vote)}
        end
      end
    end
  end

  private

  def votes_params
    params.require(:vote).permit(:value, :voteable_id, :voteable_type)
  end
end
