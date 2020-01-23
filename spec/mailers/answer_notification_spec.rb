require "rails_helper"

RSpec.describe AnswerNotificationMailer, type: :mailer do
  describe "notification" do
    let(:user) { create(:user, email: 'to@example.org') }
    let!(:answer) { create(:answer, user: user) }
    let(:mail) { AnswerNotificationMailer.notification(answer, user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Notification')
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to have_text("A question you've subscribed to got answered!")
      expect(mail.body.encoded).to have_text(answer.question.title)
      expect(mail.body.encoded).to have_text(answer.body)
    end
  end
end
