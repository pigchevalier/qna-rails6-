require 'rails_helper'

feature 'User can subscribe to question', %q{
  In order to recieve mail about new answer to question
  As an authenticated user
  I'd like to be able to subscribe
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    describe 'author' do
      background do
        sign_in(user)
        visit questions_path
        click_on 'Create question'
        fill_in 'Title', with: 'Title?'
        fill_in 'Body', with: 'text'
        click_on 'Create'
      end
      scenario 'create question' do
        expect(page).to have_content 'Unsubscribe'
      end

      scenario 'unsubscribe from question' do
        click_on 'Unsubscribe'
        expect(page).to_not have_content 'Unsubscribe'
        expect(page).to have_content 'Subscribe'
      end
    end

    describe 'not author' do
      background do
        sign_in(user)
        visit question_path(id: question)
      end

      scenario 'subscribe to question' do
        click_on 'Subscribe'
        expect(page).to_not have_content 'Subscribe'
        expect(page).to have_content 'Unsubscribe'
      end

      scenario 'unsubscribe from question' do
        click_on 'Subscribe'
        click_on 'Unsubscribe'
        expect(page).to_not have_content 'Unsubscribe'
        expect(page).to have_content 'Subscribe'
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    background do
      visit question_path(id: question)
    end

    scenario 'tries to subscribe to question' do
      expect(page).to_not have_content 'Subscribe'
    end

    scenario 'tries to unsubscribe to question' do
      expect(page).to_not have_content 'Unsubscribe'
    end
  end
end
