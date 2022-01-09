require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do

  given!(:answer) { create(:answer) }
  given(:user_not_author) { create(:user) }

  describe 'Authenticated user', js: true do
    scenario 'edit his answer' do
      sign_in(answer.user)
      visit question_path(id: answer.question)
      
      click_on 'Edit'
  
      within '.answers' do
        fill_in 'Your answer', with: 'edited_answer_text'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited_answer_text'
        expect(page).to_not have_selector 'textarea'
      end
    end
    
    scenario 'edit his answer with errors' do
      sign_in(answer.user)
      visit question_path(id: answer.question)

      click_on 'Edit'
  
      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save'
      end
    
      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries edit others user's answer" do
      sign_in(user_not_author)
      visit question_path(id: answer.question)

      expect(page).to_not have_link 'Edit'
    end
  end

  scenario "Unauthenticated user can not edit an answer", js: true do
    visit question_path(id: answer.question)
    
    expect(page).to_not have_link 'Edit'
  end
end

