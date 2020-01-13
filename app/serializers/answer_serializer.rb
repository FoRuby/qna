class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at

  has_many :votes
  has_many :files
  has_many :links
end
