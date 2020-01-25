FactoryBot.define do
  factory :link do
    sequence(:name) { |n| "Link#{n}" }
    sequence(:url) { |n| "https://www.testlink#{n}.com" }
    linkable { create(:question) }
  end

  factory :gist, parent: :link do
    sequence(:name) { |n| "Gist#{n}" }
    sequence(:url) { |n| "https://gist.github.com/name/gist_id_#{n}" }
    gist_body { 'GistBody' }
  end

  trait :invalid_link do
    name { nil }
    url { nil }
  end
end
