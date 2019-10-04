FactoryBot.define do

  factory :question do
    title { "QuestionTitle" }
    body { "QuestionBody" }

    after :create do |question|
      create_list :answer_with_index, 3, question: question
    end
  end

  factory :question_with_index, parent: :question do
    sequence(:title){ |n| "QuestionTitle#{n}" }
    sequence(:body){ |n| "QuestionBody#{n}" }
  end

  trait :invalid_question do
    title { nil }
  end
end
