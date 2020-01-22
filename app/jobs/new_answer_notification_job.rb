class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.question.subscriptions.find_each do |subscription|
      unless subscription.user.author_of?(answer)
        NewAnswerMailer.notification(answer, subscription.user).try(:deliver_later)
      end
    end
  end
end
