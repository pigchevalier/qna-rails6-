require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:questions).dependent(:destroy) }
  end

  let(:user_not_athor) { create(:user, email: '2@2.com') }
  let(:answer) { create(:answer) }
  it 'athor of' do
    expect(answer.user.author_of?(answer)).to be(true)
  end

  it 'not athor of' do
    expect(user_not_athor.author_of?(answer)).to be(false)
  end
end
