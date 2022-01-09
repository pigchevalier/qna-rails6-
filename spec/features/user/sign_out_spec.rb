require 'rails_helper'

feature 'User can sign out', %q{
  In order quit 
  As an authenticated user
  I'd like to be able to sign out
} do

  given(:user) { create(:user) }

  background do
    sign_in(user)
  end

  scenario 'Authenticated user tries to sign out' do
    click_button 'Log out'

    expect(page).to have_content 'Questions'
  end
end
