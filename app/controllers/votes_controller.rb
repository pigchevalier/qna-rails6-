class VotesController < ApplicationController
  include Serialized
  include ResourceFinder

  before_action :authenticate_user!

  authorize_resource

  def create
    @obj = parentable
    if !can?(:update, @obj)
      @vote = current_user.votes.build(votes_params)
      respond_to do |format|
        if @vote.save
          format.json { render_json([@obj.rating, @vote.id]) }
        else
          format.json { render_errors(@vote)}
        end
      end
    end
  end

  def destroy 
    @vote = Vote.find(params[:id])   
    obj = @vote.voteable
    if can?(:destroy, @vote)
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
    if params[:mark] == '+'
      {value: 1, voteable_id: @obj.id, voteable_type: @obj.class}
    elsif params[:mark] == '-'
      {value: -1, voteable_id: @obj.id, voteable_type: @obj.class}
    end
  end
end
