require 'rails_helper'

feature 'User can create answer', %q{
  In order to get answer on question from a community
  As an authenticated user
  I'd like to be able to create answer
} do
  
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(question.user)

      visit question_path(id: question)
    end

    scenario 'create answer' do
      fill_in 'Body', with: 'answer_text'
      click_button 'Create'
  
      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'answer_text'
      end
    end
    
    scenario 'create answer with errors' do
      click_on 'Create'
    
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario "Unauthenticated user tries to create an answer", js: true do
    visit question_path(id: question)
    
    expect(page).to_not have_button 'Create'
  end
end
