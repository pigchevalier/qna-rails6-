require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    it { should belong_to(:question) }
    it { should have_many(:links).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :body }
  end

  it 'have many attached file' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end 

  it { should accept_nested_attributes_for :links }
end
