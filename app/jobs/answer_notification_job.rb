class AnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    AnswerNotificationService.send_notification(answer)
  end
end
