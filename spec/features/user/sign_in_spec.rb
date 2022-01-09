require 'rails_helper'

feature 'User can sign in', %q{
  In order ask questions
  As an unauthenticated user
  I'd like to be able to sign in
} do

  given(:user) { create(:user) }

  scenario 'Registred user tries to sign in' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Unregistred user tries to sig in' do
    visit new_user_session_path
    fill_in 'Email', with: '1@1.com'
    fill_in 'Password', with: '111111'
    click_button 'Log in'

    expect(page).to have_content 'Invalid Email or password'
  end
end
