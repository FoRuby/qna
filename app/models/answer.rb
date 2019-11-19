class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many_attached :files

  default_scope -> { order(best: :desc, created_at: :asc) }

  validates :body, presence: true
  validates :best, uniqueness: { scope: :question_id }, if: :best?

  def mark_as_best!
    transaction do
      question.answers.where.not(id: id).update_all(best: false)
      update!(best: true)
    end
  end
end
