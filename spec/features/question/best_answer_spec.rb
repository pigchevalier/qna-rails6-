require 'rails_helper'

feature 'Author of question can set best answer', %q{
  In order to set best answer from a community
  As an author of question
  I'd like to be able to set best answer
} do
  given!(:question) { create(:question) }
  given(:user_not_author) { create(:user) }
  given!(:answer1) { create(:answer, question: question) }
  given!(:answer2) { create(:answer, question: question) }

  describe 'Authenticated user' do
    scenario 'set best answer for his question' do
      sign_in(question.user)
      visit question_path(id: question)

      expect(page).to_not have_content 'Best answer'
      within("div##{answer1.id}.answer") do
        click_link('Set as best')
      end
      expect(page).to have_content 'Best answer'
    end
    scenario 'change best answer for his question' do
      question.best_answer = answer1
      question.save
      sign_in(question.user)
      visit question_path(id: question)
      expect(page).to have_content 'Best answer'
      within("##{answer2.id}.answer") do
        click_link('Set as best')
      end
      expect(page).to have_content 'Best answer'
    end
    scenario "tries to set best answer for other user's question" do
      sign_in(user_not_author)
      visit question_path(id: question)

      expect(page).to_not have_link 'Set as best'
    end
  end

  describe 'Unauthenticated user' do
    scenario "tries to set best answer for question" do
      visit question_path(id: question)

      expect(page).to_not have_link 'Set as best'
    end
  end 
end
