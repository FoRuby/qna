require "rails_helper"

RSpec.describe DailyDigestMailer, type: :mailer do
  describe 'digest' do
    let(:user) { create(:user, email: 'to@example.org') }
    let!(:questions) { create_list(:question, 2, user: user, created_at: 1.days.ago) }
    let!(:old_questions) { create_list(:question, 2, user: user, created_at: 2.days.ago) }
    let(:mail) { DailyDigestMailer.digest(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Digest')
      expect(mail.to).to eq(['to@example.org'])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the question body' do
      questions.each do |question|
        expect(mail.body).to have_text(question.title)
      end
    end

    it 'does not renders old_questions body' do
      old_questions.each do |question|
        expect(mail.body).to_not have_text(question.title)
      end
    end
  end
end
