require 'rails_helper'

RSpec.describe Vote, type: :model do

  describe 'associations' do
    it { should belong_to :user }
    it { should belong_to :votable }
  end

  describe 'validations' do
    it { should validate_presence_of :value }
    it { should validate_presence_of :user }

    describe 'uniqueness of user scoped to votable' do
      let(:user) { create(:user) }
      let(:question) { create(:question, user: user) }
      let(:answer) { create(:answer, question: question, user: user) }
      let!(:voted_question) { create(:vote, user: user, votable: question, value: 1) }
      let!(:voted_answer) { create(:vote, user: user, votable: answer, value: 1) }

      it { should validate_uniqueness_of(:user).scoped_to([:votable_id, :votable_type]) }
    end
  end
end
