require 'rails_helper'

RSpec.describe AnswerNotificationJob, type: :job do
  let!(:answer) { create(:answer) }
  let(:service) { double('AnswerNotificationService') }

  before do
    allow(AnswerNotificationService).to receive(:new).and_return(service)
  end

  it 'calls AnswerNotification#send_notification' do
    expect(service).to receive(:send_notification).with(answer)

    AnswerNotificationJob.perform_now(answer)
  end
end
