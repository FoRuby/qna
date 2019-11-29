require 'rails_helper'

RSpec.describe AnswerRewardService, type: :service do

  describe '#reward AnswerRewardService' do
    context 'change reward user if reward present' do
      let!(:question) { create(:question) }
      let!(:reward) { create(:reward, question: question, user: nil) }
      let!(:answer) { create(:answer, question: question) }

      before { AnswerRewardService.new(answer).reward }
      subject { reward.user }

      it { is_expected.to eq answer.user }
    end

    context 'does not change reward user if reward does not present' do
      let!(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question) }

      before { AnswerRewardService.new(answer).reward }
      subject { question.reward }

      it { is_expected.to be_nil }
    end
  end
end
