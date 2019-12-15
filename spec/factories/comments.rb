FactoryBot.define do
  factory :comment do
    sequence(:body) { |n| "CommentBody#{n}" }
    commentable { create(:question)}
    user
  end
end
