class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  default_scope -> { order(:created_at) }

  validates :body, presence: true

  def mark_as_best
    unless best?
      question.answers.where(best: true).update_all(best: false)
      update(best: true)
    end
  end

  def best?
    best
  end
end
