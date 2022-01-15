require 'rails_helper'

feature 'User can add links to question', %q{
  In order to add info to question
  As an author of question
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:url) {'https://gist.github.com/pigchevalier/d11aa8d32efd95c437fe983aa5d675bc'}

  describe ' User create question', js: true do
    scenario 'User add link'do
      sign_in(user)
      visit new_question_path
  
      fill_in 'Title', with: 'Title?'
      fill_in 'Body', with: 'text'
      fill_in 'Link name', with: 'My link'
      fill_in 'Url', with: url
      click_button 'Create'
  
      expect(page).to have_link 'My link', href: url
      expect(page).to have_content 'Qna gist'
    end
  
    scenario 'User add link with errors' do  
      sign_in(user)
      visit new_question_path
  
      fill_in 'Title', with: 'Title?'
      fill_in 'Body', with: 'text'
      fill_in 'Link name', with: 'My link'
      fill_in 'Url', with: 'url'
      click_button 'Create'
  
      expect(page).to_not have_link 'My link', href: 'url'
      expect(page).to have_content 'is not a valid URL'
    end
  end

  describe 'Author edit question', js: true do
    given!(:question) { create(:question, user: user) }
    scenario 'Author add link'do
      sign_in(user)
      visit questions_path

      click_on 'Edit'
  
      within '.questions' do
        fill_in 'Title of question', with: 'edited_question_title'
        fill_in 'Your question', with: 'edited_question_text'
        click_on 'add link'
        fill_in 'Link name', with: 'My link'
        fill_in 'Url', with: url
        click_button 'Save'

        expect(page).to have_link 'My link', href: url
        #тело гист появляется только после обновления страницы(скрипт не срабатывает после просто рендера)
        page.refresh
        expect(page).to have_content 'Qna gist'
      end
    end
  
    scenario 'Author add link with errors' do
      sign_in(user)
      visit questions_path
  
      click_on 'Edit'
  
      within '.questions' do
        fill_in 'Title of question', with: 'edited_question_title'
        fill_in 'Your question', with: 'edited_question_text'
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
