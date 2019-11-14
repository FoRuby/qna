class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  default_scope -> { order(best: :desc, created_at: :asc) }

  validates :body, presence: true
  validates :best, inclusion: [true], on: :already_best

  def mark_as_best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
