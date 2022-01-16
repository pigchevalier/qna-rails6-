require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_one(:best_answer).with_foreign_key('best_of_question_id').class_name('Answer').dependent(:nullify) }
    it { should have_many(:links).dependent(:destroy) }
    it { should have_many(:rewards).dependent(:destroy) }
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
end
