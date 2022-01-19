FactoryBot.define do
  factory :vote do
    value { 1 }
    voteable { FactoryBot.build(:question) }
    user
  end
end
