require 'rails_helper'

feature 'User can vote to answer', %q{
  In order to rating answer on question from a community
  As an authenticated user
  I'd like to be able to vote to answer
} do
  
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user' do
    describe 'not author' do
      background do
        sign_in(question.user)
        visit question_path(id: question)
      end

      scenario 'vote + to answer', js: true do  
        click_on 'Vote +'
        expect(page).to have_content 'Rating: 1'
        expect(page).to have_link 'Unvote'
        expect(page).to_not have_link 'Vote +'
        expect(page).to_not have_link 'Vote -'
      end
      
      scenario 'vote - to answer', js: true do  
        click_on 'Vote -'
        expect(page).to have_content 'Rating: -1'
        expect(page).to have_link 'Unvote'
        expect(page).to_not have_link 'Vote +'
        expect(page).to_not have_link 'Vote -'
      end
        
      scenario 'unvote to answer', js: true do
        click_on 'Vote -'
        click_on 'Unvote'
        expect(page).to have_content 'Rating: 0'
        expect(page).to_not have_link 'Unvote'
        expect(page).to have_link 'Vote +'
        expect(page).to have_link 'Vote -'
      end
    end
    
    scenario 'author tries vote to answer' do
      sign_in(answer.user)
      visit question_path(id: question)
      expect(page).to have_content 'Rating:'
      expect(page).to_not have_link 'Unvote'
      expect(page).to_not have_link 'Vote +'
      expect(page).to_not have_link 'Vote -'
    end    
  end

  scenario "Unauthenticated user tries to vote to answer" do
    visit question_path(id: question)
    
    expect(page).to have_content 'Rating:'
    expect(page).to_not have_link 'Unvote'
    expect(page).to_not have_link 'Vote +'
    expect(page).to_not have_link 'Vote -'
  end
end
