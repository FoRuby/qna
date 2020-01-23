class AnswerNotificationService
  def send_notification(answer)
    answer.question.subscriptions.find_each(batch_size: 500) do |subscription|
      unless subscription.user.author_of?(answer)
        AnswerNotificationMailer.notification(answer, subscription.user).deliver_later
      end
    end
  end
end
