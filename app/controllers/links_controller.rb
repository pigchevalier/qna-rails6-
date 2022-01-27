class LinksController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def destroy 
    @link = Link.find(params[:id])   

    if @link.linkable.class == Answer    
      @question = @link.linkable.question
    elsif @link.linkable.class == Question
      @questions = Question.all
    end
    if can?(:destroy, @link)
      @link.destroy
    end
  end
end

