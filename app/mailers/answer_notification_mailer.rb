class AnswerNotificationMailer < ApplicationMailer
  def notification(answer, user)
    @answer = answer

    mail to: user.email
  end
end
