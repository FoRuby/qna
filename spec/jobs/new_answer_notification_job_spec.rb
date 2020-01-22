require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let!(:question) { create(:question) }
  let!(:unsubscribered_user) { create(:user) }
  let!(:subscription) { create(:subscription, question: question)}
  let!(:answer) {create(:answer, question: question)}

  it 'send answer notification for subscribed users' do
    question.subscriptions.all.each do |sub|
      expect(NewAnswerMailer).to receive(:notification).with(answer, sub.user).and_call_original
    end

    NewAnswerNotificationJob.perform_now(answer)
  end

  it 'do not send answer notification for unsubscribered users' do
    expect(NewAnswerMailer).to_not receive(:notification).with(answer, unsubscribered_user)

    NewAnswerNotificationJob.perform_now(answer)
  end
end
