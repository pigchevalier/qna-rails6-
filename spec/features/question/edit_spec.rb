require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
} do

  given!(:question) { create(:question) }
  given(:user_not_author) { create(:user) }

  describe 'Authenticated user', js: true do
    scenario 'edit his question' do
      sign_in(question.user)
      visit questions_path
      
      click_on 'Edit'
  
      within '.questions' do
        fill_in 'Title of question', with: 'edited_question_title'
        fill_in 'Your question', with: 'edited_question_text'
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited_question_title'
        expect(page).to have_content 'edited_question_text'
        expect(page).to_not have_selector 'textarea'
      end
    end
    
    scenario 'edit his question with errors' do
      sign_in(question.user)
      visit questions_path

      click_on 'Edit'
  
      within '.questions' do
        fill_in 'Your question', with: ''
        click_on 'Save'
      end
    
      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries edit others user's question" do
      sign_in(user_not_author)
      visit questions_path

      expect(page).to_not have_link 'Edit'
    end

    scenario 'add attached files to his question' do
      sign_in(question.user)
      visit questions_path
      
      click_on 'Edit'
  
      within '.questions' do
        fill_in 'Title of question', with: 'edited_question_title'
        fill_in 'Your question', with: 'edited_question_text'

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

        click_on 'Save'
      end
      
      expect(page).to have_link "rails_helper.rb"
      expect(page).to have_link "spec_helper.rb"
    end
  end

  scenario "Unauthenticated user can not edit an question", js: true do
    visit questions_path
    
    expect(page).to_not have_link 'Edit'
  end
end


