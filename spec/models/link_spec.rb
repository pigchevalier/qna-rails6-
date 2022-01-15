require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  it { is_expected.to validate_url_of(:url) }

  let!(:link) {create(:link)}
  let!(:link2) {create(:link, url: 'https://www.google.com/search?q=da&oq=da&aqs=chrome..69i57j0i433i512j46i512j0i433i512j46i175i199i512j46i433i512j0i433i512j0i512l2j46i433i512.913j0j7&sourceid=chrome&ie=UTF-8')}
  it 'for gist' do
    expect(link.gist).to eq(link.url.partition('#').first + '.js')
  end
  it 'for not gist' do
    expect(link2.gist).to be nil
  end
end
