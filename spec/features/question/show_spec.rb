require 'rails_helper'

feature 'User can look question and answers', %q{
  In order to look question and answers from a community
  As an user
  I'd like to be able look question and answers
} do
  
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 5, question: question) }

  scenario 'browse questions' do    
    visit question_path(id: question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end
