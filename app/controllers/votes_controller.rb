class VotesController < ApplicationController
  include Serialized
  include ResourceFinder

  before_action :authenticate_user!

  def create
    @obj = parentable
    if !current_user.author_of?(@obj)
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
    if params[:mark] == '+'
      {value: 1, voteable_id: @obj.id, voteable_type: @obj.class}
    elsif params[:mark] == '-'
      {value: -1, voteable_id: @obj.id, voteable_type: @obj.class}
    end
  end
end
