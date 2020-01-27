class Answer < ApplicationRecord
  include HasLinks
  include HasVotes
  include HasComments

  default_scope -> { order(best: :desc, created_at: :asc) }

  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true
  validates :best, uniqueness: { scope: :question_id }, if: :best?

  after_commit :send_email_to_subscribers, on: :create

  def mark_as_best!
    transaction do
      question.answers.where.not(id: id).update_all(best: false)
      update!(best: true)
      reward = question.reward
      reward.update!(user: user) if reward.present?
    end
  end

  private

  def send_email_to_subscribers
    AnswerNotificationJob.perform_later(self)
  end
end
