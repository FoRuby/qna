class Comment < ApplicationRecord
  default_scope -> { order(created_at: :asc) }

  belongs_to :user
  belongs_to :commentable, polymorphic: true, touch: true

  validates  :user, :body, :commentable, presence: true
end
