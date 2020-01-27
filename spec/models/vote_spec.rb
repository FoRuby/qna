require 'rails_helper'

RSpec.describe Vote, type: :model do

  describe 'associations' do
    it { should belong_to :user }
    it { should belong_to :votable }
  end

  describe 'validations' do
    it { should validate_presence_of :user }
    it { should validate_presence_of :value }
    it { should validate_presence_of :votable }
    it { should validate_inclusion_of(:value).in_array([-1, 0, 1]) }

    context 'uniqueness of user scoped to votable' do
      let(:user) { create(:user) }
      let(:question) { create(:question) }
      let(:answer) { create(:answer, question: question) }
      let!(:voted_question) { create(:vote, user: user, votable: question, value: 1) }
      let!(:voted_answer) { create(:vote, user: user, votable: answer, value: 1) }

      it { should validate_uniqueness_of(:user)
        .scoped_to(%i[votable_id votable_type])
        .with_message('has already voted')
      }
    end

    context 'voter can not be votable author' do
      let(:question_author) { create(:user) }
      let(:question) { create(:question, user: question_author) }

      context 'with valid voter' do
        let(:user) { create(:user) }
        let(:valid_vote) { build(:vote, user: user, votable: question, value: 1) }

        subject { valid_vote }
        it { is_expected.to be_valid }
      end

      context 'with invalid voter' do
        let(:invalid_vote) { build(:vote, user: question_author, votable: question, value: 1) }

        subject { invalid_vote }
        it { is_expected.to be_invalid }
      end
    end
  end
end
