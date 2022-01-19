require 'rails_helper'
shared_examples_for 'voteable' do
  describe 'associations' do
    it { should have_many(:votes).dependent(:destroy) }
  end

  let!(:vote) {create(:vote)}
  let(:user_not_author) {create(:user)}

  it '#rating' do
    expect(vote.voteable.rating).to eq(1)
  end

  it '#current_user_vote' do
    expect(vote.voteable.current_user_vote(vote.user)).to eq(vote.id)
  end

  it '#current_user_vote?' do
    expect(vote.voteable.current_user_vote?(vote.user)).to be(true)
    expect(vote.voteable.current_user_vote?(user_not_author)).to be(false)
  end
end
