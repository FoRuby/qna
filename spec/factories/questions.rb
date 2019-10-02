FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }
  end

  trait :invalid_question do
    title { nil }
  end
end
