require 'rails_helper'

feature 'User can remove attached file from answer', %q{
  In order to remove attached file from answer
  As an author of answer
  I'd like to be able to remove attached file from answer
} do
  given!(:answer) { create(:answer) }
  given(:user_not_author) { create(:user) }

  describe 'Authenticated user', js: true do
    background do
      answer.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'rails_helper.rb')
    end

    scenario 'remove attached file from his answer' do
      sign_in(answer.user)
      visit question_path(id: answer.question)
  
      within '.answers' do
        expect(page).to have_content 'rails_helper'
        click_on 'Remove'

        expect(page).to_not have_content 'rails_helper'
        expect(page).to_not have_content 'Remove'
      end
    end

    scenario "tries remove attached file from others user's answer" do
      sign_in(user_not_author)
      visit question_path(id: answer.question)

      expect(page).to_not have_link 'Remove'
    end
  end

  scenario "Unauthenticated user can not remove attached file from answer", js: true do
    visit question_path(id: answer.question)
    
    expect(page).to_not have_link 'Remove'
  end
end
