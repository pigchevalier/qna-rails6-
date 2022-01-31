require 'rails_helper'

describe 'Profiles Api', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/profiles/me' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/me' }
    end

    context "authorized" do
      let(:me) { create(:user) }
      let!(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before { get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers }

      it "returns 200" do
        expect(response).to be_successful
      end

      it "returns public fields" do
        %w[id email created_at updated_at].each do |attr|
          expect(json['user'][attr]).to eq me.send(attr).as_json
        end        
      end

      it "not returns private fields" do
        %w[password encrypted_password].each do |attr|
          expect(json['user']).to_not have_key(attr)
        end        
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles' }
    end

    context "authorized" do  
      let!(:users) { create_list(:user, 3) }
      let(:current_user) { users.last }
      let(:user) { users.first }
      let(:user_response) { json['users'].first }
      let!(:access_token) { create(:access_token, resource_owner_id: current_user.id) }

      before { get '/api/v1/profiles', params: { access_token: access_token.token }, headers: headers }

      it "returns 200" do
        expect(response).to be_successful
      end

      it "returns list of users without current user" do
        expect(json['users'].size).to eq users.length - 1
        expect(json['users'].include?(current_user)).to be false
      end

      it "returns public fields" do
        %w[id email created_at updated_at].each do |attr|
          expect(user_response[attr]).to eq user.send(attr).as_json
        end        
      end
    end
  end
end
