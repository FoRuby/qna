class QuestionsListSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at

  has_many :answers, serializer: AnswersListSerializer
  belongs_to :user
end
