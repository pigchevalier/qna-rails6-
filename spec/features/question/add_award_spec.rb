require 'rails_helper'

feature 'User can add reward to question', %q{
  In order to reward best answer to question
  As an author of question
  I'd like to be able to add reward
} do

  given(:user) { create(:user) }

  describe ' User create question', js: true do
    scenario 'User add reward'do
      sign_in(user)
      visit new_question_path
  
      fill_in 'Title', with: 'Title?'
      fill_in 'Body', with: 'text'
      within ('.reward') do
        fill_in 'Name', with: 'Badge'
        fill_in 'Image', with: 'https://png.pngtree.com/element_our/20190602/ourlarge/pngtree-small-red-flower-badge-decoration-illustration-image_1387105.jpg'
      end
      click_button 'Create'
  
      visit questions_path
      expect(page).to have_content 'Badge'
      expect(page).to have_css('img[src*="https://png.pngtree.com/element_our/20190602/ourlarge/pngtree-small-red-flower-badge-decoration-illustration-image_1387105.jpg"]')
    end
  
    scenario 'User add reward with errors' do  
      sign_in(user)
      visit new_question_path
  
      fill_in 'Title', with: 'Title?'
      fill_in 'Body', with: 'text'
      within ('.reward') do
        fill_in 'Name', with: 'Badge'
        fill_in 'Image', with: ''
      end
      click_button 'Create'
      
      expect(page).to have_content "can't be blank"
      visit questions_path
      expect(page).to_not have_content 'Badge'
    end
  end
end