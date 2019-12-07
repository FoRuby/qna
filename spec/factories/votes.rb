FactoryBot.define do
  factory :vote do
    user
    value { 1 }
    votable { create(:question) }
  end
end
