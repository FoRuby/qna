class AnswerNotificationService
  def self.send_notification(answer)
    answer.question.subscriptions.includes(:user).find_each do |subscription|
      unless subscription.user.author_of?(answer)
        AnswerNotificationMailer
          .notification(answer, subscription.user).deliver_later
      end
    end
  end
end
