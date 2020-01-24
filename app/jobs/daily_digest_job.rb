class DailyDigestJob < ApplicationJob
  queue_as :default

  def perform
    DailyDigestService.send_digest
  end
end
