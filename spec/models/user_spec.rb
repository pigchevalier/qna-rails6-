require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:rewards).dependent(:nullify) }
    it { should have_many(:votes).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
  end

  let(:user_not_author) { create(:user, email: '2@2.com') }
  let(:answer) { create(:answer) }
  it 'athor of' do
    expect(answer.user.author_of?(answer)).to be(true)
  end

  it 'not athor of' do
    expect(user_not_author.author_of?(answer)).to be(false)
  end

  let!(:vote) {create(:vote)}

  it '#current_user_vote' do
    expect(vote.user.vote(vote.voteable)).to eq(vote)
  end

  it '#current_user_vote?' do
    expect(vote.user.vote?(vote.voteable)).to be(true)
    expect(user_not_author.vote?(vote.voteable)).to be(false)
  end
end
