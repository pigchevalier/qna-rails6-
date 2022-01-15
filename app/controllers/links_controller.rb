class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy 
    @link = Link.find(params[:id])   
    
    if current_user.author_of?(@link.linkable) 
      if @link.linkable.class == Answer    
        @question = @link.linkable.question
      elsif @link.linkable.class == Question
        @questions = Question.all
      end
      @link.destroy
    end
  end
end

