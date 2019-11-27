class Answer < ApplicationRecord
  default_scope -> { order(best: :desc, created_at: :asc) }

  belongs_to :question
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  validates :body, presence: true
  validates :best, uniqueness: { scope: :question_id }, if: :best?

  accepts_nested_attributes_for :links, reject_if: :all_blank

  def mark_as_best!
    transaction do
      question.answers.where.not(id: id).update_all(best: false)
      update!(best: true)
    end
  end
end
