FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'foobar' }
    password_confirmation { 'foobar' }
    confirmed_at { Time.now }
  end
end
