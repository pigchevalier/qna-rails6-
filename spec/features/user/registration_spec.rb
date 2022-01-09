require 'rails_helper'

feature 'User can register', %q{
  In order create account
  As an unregistred user
  I'd like to be able to register
} do

  given(:user) { create(:user) }

  background { visit new_user_registration_path }

  scenario 'Unregister user tries to register' do
    fill_in 'Email', with: '1@1.com'
    fill_in 'Password', with: '111111'
    fill_in 'Password confirmation', with: '111111'
    click_on 'Sign up'

    expect(page).to have_content "Welcome! You have signed up successfully."
  end

  scenario 'Register user tries to register' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_on 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end
end
