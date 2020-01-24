require 'rails_helper'

RSpec.describe AnswerNotificationJob, type: :job do
  let!(:answer) { create(:answer) }
  
  it 'calls AnswerNotificationService#send_notification' do
    expect(AnswerNotificationService).to receive(:send_notification).with(answer)

    AnswerNotificationJob.perform_now(answer)
  end
end
