require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let!(:answer) { create(:answer) }
  let(:service) { double('NewAnswerNotificationService') }

  before do
    allow(NewAnswerNotificationService).to receive(:new).and_return(service)
  end

  it 'calls DaylyDigest#send_digest' do
    expect(service).to receive(:send_notification).with(answer)

    NewAnswerNotificationJob.perform_now(answer)
  end
end
