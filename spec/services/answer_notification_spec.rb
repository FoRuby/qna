require 'rails_helper'

RSpec.describe AnswerNotificationService do
  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }

  context 'sends notification to subscribers' do
    let!(:subscriptions) { create_list(:subscription, 2, question: question) }

    it 'AnswerNotificationMailer receive notification(answer, subscription.user)' do
      question.subscriptions.each do |subscription|
        expect(AnswerNotificationMailer).to receive(:notification)
          .with(answer, subscription.user).and_call_original
      end

      AnswerNotificationService.send_notification(answer)
    end
  end

  context 'does not sends notification to answer author' do
    before do
      question.subscribe!(answer.user)
      question.unsubscribe!(question.user)
    end

    it 'AnswerNotificationMailer to not receive notification(answer, subscription.user)' do
      expect(AnswerNotificationMailer).to_not receive(:notification)
        .with(answer, answer.user)

      AnswerNotificationService.send_notification(answer)
    end
  end
end
