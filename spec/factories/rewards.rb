FactoryBot.define do
  factory :reward do
    sequence(:title){ |n| "Title#{n}" }
    user { create(:user) }
    question { create(:question) }

    after(:create) do |reward|
      reward.image.attach(
        io: File.open("#{Rails.root}/spec/fixtures/files/image3.jpg"),
        filename: 'reward'
        )
    end
  end
end
