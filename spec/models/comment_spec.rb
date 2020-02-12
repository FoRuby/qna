require 'rails_helper'

RSpec.describe Comment, type: :model do

  describe 'associations' do
    it { should belong_to :user }
    it { should belong_to :commentable }
  end

  describe 'validations' do
    it { should validate_presence_of :user }
    it { should validate_presence_of :body }
    it { should validate_presence_of :commentable }
  end

  describe 'scopes' do
    let!(:question) { create(:question) }
    let!(:comment1) { create(:comment, commentable: question) }
    let!(:comment2) { create(:comment, commentable: question) }

    context 'default scope by created_at: :asc' do
      subject { question.comments.to_a }

      it { is_expected.to match_array [comment1, comment2] }
    end
  end
end
