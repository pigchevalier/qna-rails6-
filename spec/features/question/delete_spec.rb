require 'rails_helper'

feature 'Author can delete question', %q{
  In order to delete question
  As an author
  I'd like to be able to delete question
} do

  given(:user_not_author) { create(:user, email: '2@2.com') }
  
  given(:question) { create(:question) }

  describe 'athor of question' do
    scenario 'delete question' do
      sign_in(question.user)
      visit questions_path
      expect(page).to have_content question.body          
      visit question_path(id: question)
      
      click_on 'Delete question'
  
      expect(page).to have_content 'Your question successfully deleted'
      expect(page).to_not have_content question.body
    end
  end
  describe 'Not athor of question' do  
    scenario 'tries to delete question' do
      sign_in(user_not_author)          
      visit question_path(id: question)

      expect(page).to_not have_link "Delete question"
    end
  end
  describe 'Unauth. user' do  
    scenario 'tries to delete question' do        
      visit question_path(id: question)

      expect(page).to_not have_link "Delete question"
    end
  end
end
