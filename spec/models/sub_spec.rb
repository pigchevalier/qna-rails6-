require 'rails_helper'

RSpec.describe Sub, type: :model do
  describe 'associations' do
    it { should belong_to(:question) }
    it { should belong_to(:user) }
  end
end
