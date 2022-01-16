require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  describe 'GET #index' do
    let!(:user) { create(:user) }
    let!(:answer) { create(:answer, user: user)}
    let!(:rewards) { create_list(:reward, 5, answer: answer) }

    before do
      login(user)
      get :index 
    end

    it 'populates an array of rewards of current user' do
      expect(assigns(:rewards)).to match_array(rewards)
    end

    it 'renders index' do
      expect(response).to render_template :index
    end
  end
end
