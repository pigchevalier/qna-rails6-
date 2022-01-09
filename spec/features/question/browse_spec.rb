require 'rails_helper'

feature 'User can browse questions', %q{
  In order to look questions from a community
  As an user
  I'd like to be able to browse questions
} do
  
  given!(:questions) { create_list(:question, 5) }

  scenario 'browse questions' do    
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end
  end
end
