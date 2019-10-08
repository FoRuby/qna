FactoryBot.define do

  factory :answer do
    sequence(:body) { |n| "AnswerBody#{n}" }
    question { create(:question) }
    user { create(:user) }
  end

  trait :invalid_answer do
    body { nil }
  end
end
