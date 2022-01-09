require 'rails_helper'

feature 'Author can delete answer', %q{
  In order to delete answer on question from a community
  As an author
  I'd like to be able to delete answer
} do

  given!(:user_not_author) { create(:user, email: '2@2.com') }

  given!(:answer) { create(:answer) }

  describe 'athor of answer' do
    scenario 'delete answer' do
      sign_in(answer.user)          
      visit question_path(id: answer.question)
      expect(page).to have_content answer.body
      click_on 'Delete answer'
  
      expect(page).to have_content 'Your answer successfully deleted'
      expect(page).to_not have_content answer.body
    end
  end
  describe 'Not athor of answer' do  
    scenario 'tries to delete answer' do
      sign_in(user_not_author)          
      visit question_path(id: answer.question)

      expect(page).to_not have_link "Delete answer"
    end
  end
  describe 'Unauth. user' do  
    scenario 'tries to delete answer' do        
      visit question_path(id: answer.question)

      expect(page).to_not have_link "Delete answer"
    end
  end
end
