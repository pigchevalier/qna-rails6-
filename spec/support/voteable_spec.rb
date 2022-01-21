require 'rails_helper'
shared_examples_for 'voteable' do
  describe 'associations' do
    it { should have_many(:votes).dependent(:destroy) }
  end

  let!(:vote) {create(:vote)}

  it '#rating' do
    expect(vote.voteable.rating).to eq(1)
  end
end
