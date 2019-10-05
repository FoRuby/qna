FactoryBot.define do

  factory :answer do
    body { "AnswerBody" }
  end

  factory :answer_with_index, parent: :answer do
    sequence(:body) { |n| "AnswerBody#{n}" }
  end

  trait :invalid_answer do
    body { nil }
  end
end
