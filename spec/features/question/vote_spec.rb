require 'rails_helper'

feature 'User can vote to question', %q{
  In order to rating question from a community
  As an authenticated user
  I'd like to be able to vote to question
} do
  
  given!(:question) { create(:question) }

  describe 'Authenticated user' do
    describe 'not author' do
      given!(:user_not_author) { create(:user) }
      background do
        sign_in(user_not_author)
        visit questions_path
      end

      scenario 'vote + to question', js: true do  
        click_on 'Vote +'
        expect(page).to have_content 'Rating: 1'
        expect(page).to have_link 'Unvote'
        expect(page).to_not have_link 'Vote +'
        expect(page).to_not have_link 'Vote -'
      end
      
      scenario 'vote - to question', js: true do  
        click_on 'Vote -'
        expect(page).to have_content 'Rating: -1'
        expect(page).to have_link 'Unvote'
        expect(page).to_not have_link 'Vote +'
        expect(page).to_not have_link 'Vote -'
      end
        
      scenario 'unvote to question', js: true do
        click_on 'Vote -'
        click_on 'Unvote'
        expect(page).to have_content 'Rating: 0'
        expect(page).to_not have_link 'Unvote'
        expect(page).to have_link 'Vote +'
        expect(page).to have_link 'Vote -'
      end
    end
    
    scenario 'author tries vote to question' do
      sign_in(question.user)
      visit questions_path
      expect(page).to have_content 'Rating:'
      expect(page).to_not have_link 'Unvote'
      expect(page).to_not have_link 'Vote +'
      expect(page).to_not have_link 'Vote -'
    end    
  end

  scenario "Unauthenticated user tries to vote to question" do
    visit questions_path
    
    expect(page).to have_content 'Rating:'
    expect(page).to_not have_link 'Unvote'
    expect(page).to_not have_link 'Vote +'
    expect(page).to_not have_link 'Vote -'
  end
end
