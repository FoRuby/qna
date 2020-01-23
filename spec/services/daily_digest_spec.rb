require 'rails_helper'

RSpec.describe DailyDigestService do
  let(:users) { create_list(:user, 2) }
  let(:question_ids) { create_list(:question, 2, user: users.first).map(&:id) }

  it 'sends daily digest to all users' do
    users.each do |user|
      expect(DailyDigestMailer).to receive(:digest)
        .with(question_ids, user).and_call_original
    end

    subject.send_digest
  end
end
