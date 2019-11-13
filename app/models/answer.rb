class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  default_scope -> { order(:created_at) }
  scope :order_by_best, -> { partition(&:best?).flatten }

  validates :body, presence: true

  def mark_as_best!
    transaction do
      question.answers.update_all(best: false)
      update!(best: true)
    end
  end
end
