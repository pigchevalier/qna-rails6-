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

    scenario 'create answer with attached files' do
      fill_in 'Body', with: 'answer_text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Create'

      expect(page).to have_link "rails_helper.rb"
      expect(page).to have_link "spec_helper.rb"
    end
  end

  scenario "Unauthenticated user tries to create an answer", js: true do
    visit question_path(id: question)
    
    expect(page).to_not have_button 'Create'
  end
end
