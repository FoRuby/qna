FactoryBot.define do
  factory :user do
    email { "user@example.com" }
    password { "foobar" }
    password_confirmation { "foobar" }
  end

  factory :user_with_index, parent: :user do
    sequence(:email) { |n| "user#{n}@example.com" }
  end
end
