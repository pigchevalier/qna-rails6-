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

    scenario 'add attached files to his answer' do
      sign_in(answer.user)
      visit question_path(id: answer.question)

      click_on 'Edit'
  
      within '.answers' do
        fill_in 'Your answer', with: 'edited_answer_text'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

        click_on 'Save'
      end
      
      expect(page).to have_link "rails_helper.rb"
      expect(page).to have_link "spec_helper.rb"
    end
  end

  scenario "Unauthenticated user can not edit an answer", js: true do
    visit question_path(id: answer.question)
    
    expect(page).to_not have_link 'Edit'
  end
end

