require 'rails_helper'

RSpec.describe Answer, type: :model do
  it_behaves_like 'linkable'
  it_behaves_like 'votable'

  describe 'associations' do
    it { should belong_to(:question) }
    it { should belong_to(:user) }
    it 'have many attached files' do
      expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
    end
  end

  describe 'scopes' do
    let!(:question) { create(:question) }
    let!(:answer1) { create(:answer, question: question) }
    let!(:answer2) { create(:answer, :best_answer, question: question) }
    let!(:answer3) { create(:answer, question: question) }

    context 'default scope by best: :desc, created_at: :asc' do
      subject { question.answers.to_a }

      it { is_expected.to match_array [answer2, answer1, answer3] }
    end
  end

  describe 'validations' do
    context '#body' do
      it { should validate_presence_of :body }
    end

    context '#best' do
      let!(:question) { create(:question) }
      let!(:answer1) { create(:answer, :best_answer, question: question) }

      context 'existing best answer' do
        subject { answer1 }
        it { should validate_uniqueness_of(:best).scoped_to(:question_id) }
      end

      context 'new best answer' do
        subject { build(:answer, best: true, question: question) }
        it { should_not validate_uniqueness_of(:best).scoped_to(:question_id) }
      end
    end
  end

  describe 'methods' do
    context '#mark_as_best!' do
      context 'change answer attributes' do
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

      context 'change reward attributes' do
        let!(:question) { create(:question) }
        let!(:answer) { create(:answer, question: question) }

        context 'change reward user if reward present' do
          let!(:reward) { create(:reward, question: question, user: nil) }

          before { answer.mark_as_best! }
          subject { reward.user }

          it { is_expected.to eq answer.user }
        end

        context 'does not change reward user if reward does not present' do
          before { answer.mark_as_best! }
          subject { question.reward }

          it { is_expected.to be_nil }
        end
      end
    end
  end
end
