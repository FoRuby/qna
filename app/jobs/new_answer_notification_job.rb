class NewAnswerNotificationJob < ApplicationJob
  queue_as :default

  def perform(answer)
    NewAnswerNotificationService.new.send_notification(answer)
  end
end
