require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to add info to qnswer
  As an author of answer
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:url) {'https://gist.github.com/pigchevalier/d11aa8d32efd95c437fe983aa5d675bc'}

  describe ' User create answer', js: true do
    scenario 'User add link' do
      sign_in(user)
      visit question_path(question)
  
      fill_in 'Body', with: 'answer_text'
      click_on 'add link'
      fill_in 'Link name', with: 'My link'
      fill_in 'Url', with: url
      click_button 'Create'
  
      within '.answers' do
        expect(page).to have_link 'My link', href: url
        page.refresh
        expect(page).to have_content 'Qna gist'
      end
    end
  
    scenario 'User add link with errors' do
      sign_in(user)
      visit question_path(question)
  
      fill_in 'Body', with: 'answer_text'
      click_on 'add link'
      fill_in 'Link name', with: 'My link'
      fill_in 'Url', with: 'url'
      click_button 'Create'
  
      expect(page).to_not have_link 'My link', href: 'url' 
      expect(page).to have_content 'is not a valid URL'
    end
  end

  describe 'Author edit answer', js: true do
    given!(:answer) { create(:answer, question: question, user: user) }

    scenario 'Author add link' do
      sign_in(user)
      visit question_path(question)
  
      click_on 'Edit'
  
      within '.answers' do
        fill_in 'Your answer', with: 'edited_answer_text'
        click_on 'add link'
        fill_in 'Link name', with: 'My link'
        fill_in 'Url', with: url
        click_button 'Save'
  
        expect(page).to have_link 'My link', href: url
        page.refresh
        expect(page).to have_content 'Qna gist'
      end
    end
  
    scenario 'Author add link with errors' do
      sign_in(user)
      visit question_path(question)
  
      click_on 'Edit'
  
      within '.answers' do
        fill_in 'Your answer', with: 'edited_answer_text'
        click_on 'add link'
        fill_in 'Link name', with: 'My link'
        fill_in 'Url', with: 'url'
        click_button 'Save'

        expect(page).to_not have_link 'My link', href: 'url'
      end
      expect(page).to have_content 'is not a valid URL'
    end
  end
end
