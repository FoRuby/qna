require 'rails_helper'

RSpec.describe Answer, type: :model do

  context 'associations' do
    it { should belong_to(:question) }
    it { should belong_to(:user) }
  end

  describe 'scopes' do
    let!(:answer1) { create(:answer) }
    let!(:answer2) { create(:answer, :best_answer) }
    let!(:answer3) { create(:answer) }
    let!(:answer4) { create(:answer, :best_answer) }

    context 'default scope by created_at ASC' do
      subject { Answer.all.to_a }

      it { is_expected.to match_array [answer1, answer2, answer3, answer4] }
    end

    context 'order_by_best' do
      subject { Answer.all.order_by_best.to_a }

      it { is_expected.to match_array [answer2, answer4, answer1, answer3] }
    end
  end

  context 'validations' do
    it { should validate_presence_of :body }
  end

  describe '#mark_as_best!' do
    let!(:question) { create(:question) }
    let!(:best_answer) { create(:answer, :best_answer, question: question) }
    let!(:ordinary_answer) { create(:answer, question: question) }

    context 'mark ordinary answer as best' do
      before { ordinary_answer.mark_as_best! }

      context 'ordinary_answer' do
        subject { ordinary_answer }
        it { is_expected.to be_best }
      end

      context 'best_answer' do
        before { best_answer.reload }

        subject { best_answer }
        it { is_expected.not_to be_best }
      end
    end

    context 'mark best answer repeatedly' do
      before { best_answer.mark_as_best! }

      context 'best_answer' do
        subject { best_answer }
        it { is_expected.to be_best }
      end

      context 'ordinary_answer' do
        subject { ordinary_answer }
        it { is_expected.not_to be_best }
      end
    end
  end
end
