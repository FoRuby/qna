class DailyDigestMailer < ApplicationMailer
  def digest(question_ids, user)
    @questions = Question.where(id: question_ids)

    mail to: user.email
  end
end
