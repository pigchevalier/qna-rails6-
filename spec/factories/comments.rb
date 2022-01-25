FactoryBot.define do
  factory :comment do
    body {"Body"}
    commenteable { FactoryBot.build(:question) }
    user
  end
end
