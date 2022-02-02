require 'rails_helper'

RSpec.describe SubscriptionJob, type: :job do
  let!(:answer) { create(:answer) }

    it 'calls Subscription#distribution' do
      expect(Subscription).to receive(:distribution).with(answer)
      SubscriptionJob.perform_now(answer)
    end
end
