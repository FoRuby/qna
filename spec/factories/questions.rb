FactoryBot.define do

  factory :question do
    title { "QuestionTitle" }
    body { "QuestionBody" }
    author { User.first }
  end

  factory :question_with_index, parent: :question do
    sequence(:title){ |n| "QuestionTitle#{n}" }
    sequence(:body){ |n| "QuestionBody#{n}" }
  end

  factory :question_with_answers, parent: :question_with_index do
    transient do
      answers_count { 5 }
      answers_author { User.first }
    end
    after(:create) do |question, evaluator|
      create_list(:answer_with_index, evaluator.answers_count,
        question: question,
        author: evaluator.answers_author
      )
    end
  end

  trait :invalid_question do
    title { nil }
  end
end
