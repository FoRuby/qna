FactoryBot.define do
  factory :authorization do
    sequence(:uid)
    provider { 'github' }
    user
  end
end
