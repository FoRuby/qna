FactoryBot.define do

  factory :answer do
    sequence(:body) { |n| "AnswerBody#{n}" }
    question { create(:question) }
    user { create(:user) }
    best { false }
  end

  trait :invalid_answer do
    body { nil }
  end

  trait :best_answer do
    best { true }
  end
end
