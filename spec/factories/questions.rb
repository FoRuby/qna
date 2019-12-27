FactoryBot.define do

  factory :question do
    sequence(:title){ |n| "QuestionTitle#{n}" }
    sequence(:body){ |n| "QuestionBody#{n}" }
    user
  end

  factory :question_with_answers, parent: :question do
    transient do
      answers_count { 1 }
      answers_author { create(:user) }
    end
    after(:create) do |question, evaluator|
      create_list(:answer, evaluator.answers_count,
        question: question,
        user: evaluator.answers_author
      )
    end
  end

  factory :question_with_file, parent: :question do
    after(:build) do |question|
      question.files.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'image1.jpg')),
        filename: 'image1.jpg',
        content_type: 'image/jpg'
      )
    end
  end

  trait :invalid_question do
    title { nil }
    body { nil }
  end
end
