require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'associations' do
    it { should belong_to(:voteable) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of :value }
    subject { FactoryBot.build(:vote) }
    it { should validate_uniqueness_of(:user).scoped_to([:voteable_id, :voteable_type]) }
  end
end
