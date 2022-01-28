require 'rails_helper'
require 'cancan/matchers'

describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Reward }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Vote.new, create(:question, user: other) }
    it { should_not be_able_to :create, Vote.new, create(:question, user: user) }

    it { should be_able_to :update, create(:question, user: user) }
    it { should_not be_able_to :update, create(:question, user: other) }

    it { should be_able_to :update, create(:answer, user: user) }
    it { should_not be_able_to :update, create(:answer, user: other) }

    it { should be_able_to :destroy, create(:question, user: user) }
    it { should_not be_able_to :destroy, create(:question, user: other) }

    it { should be_able_to :destroy, create(:answer, user: user) }
    it { should_not be_able_to :destroy, create(:answer, user: other) }

    it { should be_able_to :destroy, create(:vote, user: user) }
    it { should_not be_able_to :destroy, create(:vote, user: other) }

    let!(:question) { create(:question, user: user )}
    let!(:vote) { create(:vote, user: user, voteable: question) }

    it { should_not be_able_to :destroy, vote }

    let!(:link) { create(:link, linkable: question) }
    let!(:o_question) { create(:question, user: other )}
    let!(:o_link) { create(:link, linkable: o_question) }

    it { should be_able_to :destroy, link }
    it { should_not be_able_to :destroy, o_link }

    it { should be_able_to :set_best_answer, create(:question, user: user) }
    it { should_not be_able_to :set_best_answer, create(:question, user: other) }
  end
end
