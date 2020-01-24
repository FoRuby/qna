require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  it 'calls DailyDigestService#send_digest' do
    expect(DailyDigestService).to receive(:send_digest)

    DailyDigestJob.perform_now
  end
end
