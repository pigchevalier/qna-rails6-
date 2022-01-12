require 'rails_helper'

feature 'User can remove attached file from question', %q{
  In order to remove attached file from question
  As an author of question
  I'd like to be able to remove attached file from question
} do
  given!(:question) { create(:question) }
  given(:user_not_author) { create(:user) }

  describe 'Authenticated user', js: true do
    background do
      question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
    end

    scenario 'remove attached file from his question' do
      sign_in(question.user)
      visit questions_path
  
      within '.questions' do
        expect(page).to have_content 'rails_helper'
        click_on 'Remove'

        expect(page).to_not have_content 'rails_helper'
        expect(page).to_not have_content 'Remove'
      end
    end

    scenario "tries remove attached file from others user's question" do
      sign_in(user_not_author)
      visit questions_path

      expect(page).to_not have_link 'Remove'
    end
  end

  scenario "Unauthenticated user can not remove attached file from question", js: true do
    visit questions_path
    
    expect(page).to_not have_link 'Remove'
  end
end
