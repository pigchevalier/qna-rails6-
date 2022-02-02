require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:rewards).dependent(:nullify) }
    it { should have_many(:votes).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:subs).dependent(:destroy) }
  end

  let(:user_not_author) { create(:user, email: '2@2.com') }

  let!(:vote) {create(:vote)}

  it '#current_user_vote' do
    expect(vote.user.vote(vote.voteable)).to eq(vote)
  end

  it '#current_user_vote?' do
    expect(vote.user.vote?(vote.voteable)).to be(true)
    expect(user_not_author.vote?(vote.voteable)).to be(false)
  end

  let!(:sub) {create(:sub) }

  it '#current_user_sub' do
    expect(sub.user.sub(sub.question)).to eq(sub)
  end

  it '#current_user_sub?' do
    expect(sub.user.sub?(sub.question)).to be(true)
    expect(user_not_author.sub?(sub.question)).to be(false)
  end
end
