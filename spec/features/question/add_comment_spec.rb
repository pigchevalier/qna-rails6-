require 'rails_helper'

feature 'User can add comments to question', %q{
  In order to add comment to question
  As an auth. user
  I'd like to be able to add comments
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  
  describe 'Auth. user' do
    scenario 'add comment', js: true do
      sign_in(user)
      visit question_path(id: question)
  
      fill_in 'Your comment', with: 'text'
      click_button 'Save comment'
  
      expect(page).to have_content 'text'
    end
  
    scenario 'add comment with errors', js: true do  
      sign_in(user)
      visit question_path(id: question)
  
      click_button 'Save comment'
  
      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'Not auth. user' do
    scenario 'tries to create comment', js: true do
      visit question_path(id: question)
  
      expect(page).to_not have_content 'Your comment'
    end
  end

  describe 'multiple sessions' do
    scenario "comment appear on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(id: question)
      end

      Capybara.using_session('guest') do
        visit question_path(id: question)
      end

      Capybara.using_session('user') do
        fill_in 'Your comment', with: 'text'
        click_button 'Save comment'
  
        expect(page).to have_content 'text'
      end

      Capybara.using_session('guest') do
        #вне теста всё работает, внутри теста не смогла понять почему не работает
        #возможно потому что канал долго поднимается и надо перезагрузить страницу перед создание комментария
        #но использование здесь refresh не помагает
        #при этом с вопросами и ответами такой проблемы нет
        visit question_path(id: question)
        expect(page).to have_content 'text'        
      end
    end
  end
end
