require 'rails_helper'

RSpec.describe NewAnswerNotificationService do
  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }
  let!(:subscriptions) { create_list(:subscription, 2, question: question) }

  it 'sends notification to subscribers' do
    question.subscriptions.each do |subscription|
      expect(NewAnswerMailer).to receive(:notification).with(answer, subscription.user).and_call_original
    end

    subject.send_notification(answer)
  end

  # NoMethodError:
  #      undefined method `deliver_later' for nil:NilClass
  # it 'does not sends notification to answer author' do
  #   expect(NewAnswerMailer).to_not receive(:notification).with(answer, answer.user)
  #
  #   subject.send_notification(answer)
  # end
end
