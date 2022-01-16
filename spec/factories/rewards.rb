FactoryBot.define do
  factory :reward do
    sequence(:name) { |n| "Reward#{n}" }
    image { "https://png.pngtree.com/element_our/20190602/ourlarge/pngtree-small-red-flower-badge-decoration-illustration-image_1387105.jpg" }
    question
  end
end
