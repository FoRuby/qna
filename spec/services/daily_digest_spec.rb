require 'rails_helper'

RSpec.describe DailyDigestService do
  let(:users) { create_list(:user, 2) }
  let(:questions) { create_list(:question, 2, user: users.first) }

  it 'sends daily digest to all users' do
    users.each do |user|
      expect(DailyDigestMailer).to receive(:digest).with(user).and_call_original
    end

    DailyDigestService.send_digest
  end
end
