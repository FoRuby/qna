require 'rails_helper'

RSpec.describe Question, type: :model do
  it_behaves_like 'linkable'
  it_behaves_like 'votable'
  it_behaves_like 'commentable'

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_one(:reward).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }

    context 'have many attached files' do
      subject { Question.new.files }
      it { is_expected.to be_an_instance_of(ActiveStorage::Attached::Many) }
    end
  end

  describe 'nested attributes' do
    it { should accept_nested_attributes_for :reward }
  end

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end

  describe 'subscription' do
    let(:question) { build(:question) }

    it 'calls ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)#.and_call_original

      question.save!
    end
  end
end
