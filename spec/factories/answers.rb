FactoryBot.define do

  factory :answer do
    sequence(:body) { |n| "AnswerBody#{n}" }
    question { create(:question) }
    user { create(:user) }
    best { false }
  end

  factory :answer_with_link, parent: :answer do
    after(:build) { |answer| create(:link, linkable: answer) }
  end

  trait :invalid_answer do
    body { nil }
  end

  trait :best_answer do
    best { true }
  end
end
