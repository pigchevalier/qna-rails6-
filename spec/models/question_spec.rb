require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_one(:best_answer).with_foreign_key('best_of_question_id').class_name('Answer').dependent(:nullify) }
    it { should have_many(:links).dependent(:destroy) }
    it { should have_many(:rewards).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end

  it 'have many attached file' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end  

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :rewards }

  let!(:user) { create(:user) }
  let!(:answer) { create(:answer, user: user)}
  let!(:reward) { create(:reward, answer: answer, user: user) }

  it 'set best answer' do
    answer.question.set_best_answer(answer.id, user)
    expect(answer.question.best_answer).to eq(answer)
    expect(user.rewards.count).to be(1)
    expect(answer.reward.user).to be(user)
  end

  it_behaves_like 'voteable'
end
