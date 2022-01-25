require 'rails_helper'

feature 'User can add comments to answer', %q{
  In order to add comment to answer
  As an auth. user
  I'd like to be able to add comments
} do

  given!(:user) { create(:user) }
  given!(:answer) { create(:answer) }
  
  describe 'Auth. user' do
    scenario 'add comment', js: true do
      sign_in(user)
      visit question_path(id: answer.question)

      within '.answers' do
        fill_in 'Your comment', with: 'text'
        click_button 'Save comment'
  
        expect(page).to have_content 'text'
      end
    end
  
    scenario 'add comment with errors', js: true do  
      sign_in(user)
      visit question_path(id: answer.question)

      within '.answers' do
        click_button 'Save comment'
  
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  describe 'Not auth. user', js: true do
    scenario 'tries to create comment' do
      visit question_path(id: answer.question)

      within '.answers' do
        expect(page).to_not have_content 'Your comment'
      end
    end
  end

  describe 'multiple sessions' do
    scenario "comment appear on another user's page", js: true do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(id: answer.question)
      end

      Capybara.using_session('guest') do
        visit question_path(id: answer.question)
      end

      Capybara.using_session('user') do
        within ".answers" do
          fill_in 'Your comment', with: 'sdf'
          click_button 'Save comment'
          
          expect(page).to have_content 'sdf'
        end
      end

      Capybara.using_session('guest') do
        #вне теста всё работает, внутри теста не смогла понять почему не работает
        #возможно потому что канал долго поднимается и надо перезагрузить страницу перед создание комментария
        #но использование здесь refresh не помагает
        #при этом с вопросами и ответами такой проблемы нет
        expect(page).to have_content 'sdf'        
      end
    end
  end
end
