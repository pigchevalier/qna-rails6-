require 'rails_helper'

RSpec.describe Subscription do
  let(:user1) { create(:user) }
  let(:user2) { create(:user) }
  let(:user_not_sub) { create(:user) }
  let(:question) { create(:question, user: user1) }
  let(:answer) { create(:answer, question: question) }
  let!(:sub1) { create(:sub, user: user1, question: question) }
  let!(:sub2) { create(:sub, user: user2, question: question) }

  it 'sends mail to users that subs on question' do
    expect(SubscriptionMailer).to receive(:digest).with(user1, question, answer).and_call_original
    expect(SubscriptionMailer).to receive(:digest).with(user2, question, answer).and_call_original
    expect(SubscriptionMailer).to_not receive(:digest).with(user_not_sub, question, answer).and_call_original
    Subscription.distribution(answer)
  end
end

