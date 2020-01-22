class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.where(created_at: 1.days.ago..Time.now)

    mail to: user.email
  end
end
