FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "#{n}MyText" }
    question
    user

    trait :invalid do
      body { nil }
    end
  end
end
