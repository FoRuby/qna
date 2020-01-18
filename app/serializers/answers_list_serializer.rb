class AnswersListSerializer < ActiveModel::Serializer
  attributes :id, :body, :best, :question_id, :created_at, :updated_at
  belongs_to :user
end
