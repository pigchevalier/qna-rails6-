require 'rails_helper'

feature 'User can look rewards', %q{
  In order to look rewards from a community
  As an user
  I'd like to be able look rewards
} do
  let!(:user) { create(:user) }
  let!(:answer) { create(:answer, user: user)}
  let!(:reward) { create(:reward, answer: answer, user: user) }

  scenario 'user browse rewards' do  
    sign_in(user)  
    visit rewards_path

    expect(page).to have_content reward.question.title
    expect(page).to have_content reward.name
    expect(page).to have_css("img[src*='#{reward.image}']")
  end

  scenario 'unauth. user tries to browse rewards' do    
    visit rewards_path

    expect(page).to_not have_content reward.question.title
    expect(page).to_not have_content reward.name
    expect(page).to_not have_css("img[src*='#{reward.image}']")
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
