FactoryBot.define do
  factory :link do
    name { "MyString" }
    url { "https://gist.github.com/pigchevalier/d11aa8d32efd95c437fe983aa5d675bc" }
    linkable { Question.new }
  end
end
