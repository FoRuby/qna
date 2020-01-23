# Preview all emails at http://localhost:3000/rails/mailers/answer_notification
class AnswerNotificationPreview < ActionMailer::Preview
  def notification
    AnswerNotificationMailer.notification(Answer.first, User.first)
  end
end
