require 'rails_helper'

RSpec.describe Answer, type: :model do

  context 'associations' do
    it { should belong_to(:question) }
    it { should belong_to(:user) }
  end

  context 'validations' do
    it { should validate_presence_of :body }
  end

  describe '#best?' do
    let(:best_answer) { create(:answer, :best_answer) }
    let(:ordinary_answer) { create(:answer) }

    context 'best_answer' do
      subject { best_answer.best }
        it { is_expected.to be_truthy }
    end

    context 'ordinary_answer' do
      subject { ordinary_answer.best }
        it { is_expected.to be_falsey }
    end
  end

  describe '#mark_as_best' do
    let!(:question) { create(:question) }
    let!(:best_answer) { create(:answer, :best_answer, question: question) }
    let!(:ordinary_answer) { create(:answer, question: question) }

    it 'mark best answer repeatedly' do
      best_answer.mark_as_best
      expect(ordinary_answer.reload.best).to be_falsey
      expect(best_answer.reload.best).to be_truthy
    end

    it 'mark ordinary answer as best' do
      ordinary_answer.mark_as_best
      expect(ordinary_answer.reload.best).to be_truthy
      expect(best_answer.reload.best).to be_falsey
    end
  end
end
