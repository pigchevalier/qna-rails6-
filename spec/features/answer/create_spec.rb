require 'rails_helper'

feature 'User can create answer', %q{
  In order to get answer on question from a community
  As an authenticated user
  I'd like to be able to create answer
} do
  
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(question.user)

      visit question_path(id: question)
    end

    scenario 'create answer' do
      fill_in 'Body', with: 'answer_text'
      click_button 'Create'
  
      expect(page).to have_content 'Your answer successfully created'
      expect(page).to have_content 'answer_text'
    end
    
    scenario 'create answer with errors' do
      click_on 'Create'
    
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario "Unauthenticated user tries to create an answer" do
    visit question_path(id: question)
    fill_in 'Body', with: 'answer_text'
    click_on 'Create'

    expect(page).to have_content "You need to sign in or sign up before continuing."
  end
end
