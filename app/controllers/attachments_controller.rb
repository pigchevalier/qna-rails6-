class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @file = ActiveStorage::Attachment.find(params[:file_id])
    if current_user.author_of?(@file.record)      
      @file.purge
    end
    if @file.record.class == Answer
      @question = @file.record.question
    elsif @file.record.class == Question
      @questions = Question.all
    end
  end
end
