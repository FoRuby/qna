class DailyDigestService
  def send_digest
    @question_ids = select_question_ids

    User.find_each(batch_size: 500) do |user|
      DailyDigestMailer.digest(@question_ids, user).deliver_later
    end
  end

  def select_question_ids
    Question.where(created_at: 1.days.ago..Time.now).pluck(:id)
  end
end
