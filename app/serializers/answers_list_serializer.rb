class AnswersListSerializer < ActiveModel::Serializer
  attributes :id, :body, :user_id, :best, :created_at, :updated_at
end
