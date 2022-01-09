FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "#{n}MyString" }
    body { "MyText" }
    user

    trait :invalid do
      title { nil }
    end
  end
end
