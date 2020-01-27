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

  describe 'callbacks' do
    context 'after_create' do
      let(:user) { create(:user) }
      let(:question) { create(:question, user: user) }

      it 'create new subscription' do
        expect{question}.to change(Subscription, :count).by(1)
      end

      it 'assign question user to new subscription user' do
        expect(question.subscriptions.last.user).to eq user
      end

      it 'assign question to new subscription # QUESTION: ' do
        expect(question.subscriptions.last.question).to eq question
      end
    end
  end

  describe 'methods' do
    context '#subscribe!(user)' do
      let!(:question) { create(:question) }
      let(:user) { create(:user) }

      it 'create new subscription' do
        expect{question.subscribe!(user)}.to change(Subscription, :count).by(1)
      end

      it 'assign new subscription' do
        question.subscribe!(user)

        expect(question.subscriptions.last.user).to eq user
        expect(question.subscriptions.last.question).to eq question
      end
    end

    context '#unsubscribe!(user)' do
      let!(:subscription) { create(:subscription) }

      it 'destroy subscription' do
        expect{subscription.question.unsubscribe!(subscription.user)}
          .to change(Subscription, :count).by(-1)
      end
    end
  end
end
