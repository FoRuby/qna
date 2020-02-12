FactoryBot.define do

  factory :answer do
    sequence(:body) { |n| "AnswerBody#{n}" }
    question
    user
    best { false }
  end

  factory :answer_with_link, parent: :answer do
    after(:build) { |answer| create(:link, linkable: answer) }
  end

  factory :answer_with_file, parent: :answer do
    after(:build) do |answer|
      answer.files.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'image1.jpg')),
        filename: 'image1.jpg',
        content_type: 'image/jpg'
      )
    end
  end

  trait :invalid_answer do
    body { nil }
  end

  trait :best_answer do
    best { true }
  end
end
