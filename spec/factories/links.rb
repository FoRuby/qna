FactoryBot.define do
  factory :link do
    sequence(:name){ |n| "Link#{n}" }
    sequence(:url){ |n| "https://www.testlink#{n}.com" }
    linkable { create(:question) }
  end

  trait :invalid_link do
    name { nil }
    url { nil }
  end
end
