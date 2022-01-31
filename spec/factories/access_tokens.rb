FactoryBot.define do
  factory :access_token, class: 'Doorkeeper::AccessToken' do
    association :application, factory: :oauth_application
    expires_in { 2.hours }
    resource_owner_id { create(:user).id }
    scopes { 'public' }
  end
end
