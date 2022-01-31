FactoryBot.define do
  factory :oauth_application, class: 'Doorkeeper::Application' do
    name { "Test" }
    redirect_uri { 'urn:ietf:wg:oauth:2.0:oob' }
    uid { '1234' }
    secret { '1111' }
    scopes { 'public' }
  end
end
