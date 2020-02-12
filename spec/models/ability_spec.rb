require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, :all }
    it { should_not be_able_to :manage, :all }
    it { should be_able_to :search, User }
  end

  describe 'for user' do
    let(:user) { create(:user) }
    let(:other) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:other_question) { create(:question, user: other) }
    let(:answer) { create(:answer, user: user) }
    let(:other_answer) { create(:answer, user: other) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'Question' do
      it { should be_able_to :create, Question }

      it { should be_able_to :update, question }
      it { should_not be_able_to :update, other_question }

      it { should be_able_to :destroy, question }
      it { should_not be_able_to :destroy, other_question }
    end

    context 'Subscription' do
      # может подписаться на чужой вопрос
      it { should be_able_to :subscribe, other_question }
      # не может подписаться на свой вопрос, т.к. подписан при создании
      it { should_not be_able_to :subscribe, question }

      it { should be_able_to :unsubscribe, question }
      it { should_not be_able_to :unsubscribe, other_question }
    end

    context 'Answer' do
      it { should be_able_to :create, Answer }

      it { should be_able_to :update, answer }
      it { should_not be_able_to :update, other_answer }

      it { should be_able_to :destroy, answer }
      it { should_not be_able_to :destroy, other_answer }

      it { should be_able_to :mark_best, create(:answer, question: question) }
      it { should_not be_able_to :mark_best, create(:answer, question: other_question) }
    end

    context 'Comment' do
      it { should be_able_to :create, Comment }
    end

    context 'Vote' do
      it { should be_able_to :vote, other_question }
      it { should_not be_able_to :vote, question }

      it { should be_able_to :vote, other_answer }
      it { should_not be_able_to :vote, answer }
    end

    context 'Link' do
      it { should be_able_to :destroy, create(:link, linkable: question) }
      it { should_not be_able_to :destroy, create(:link, linkable: other_question) }

      it { should be_able_to :destroy, create(:link, linkable: answer) }
      it { should_not be_able_to :destroy, create(:link, linkable: other_answer) }
    end

    context 'Files' do
      it { should be_able_to :destroy, create(:question_with_file, user: user).files.first }
      it { should_not be_able_to :destroy, create(:question_with_file, user: other).files.first }

      it { should be_able_to :destroy, create(:answer_with_file, user: user).files.first }
      it { should_not be_able_to :destroy, create(:answer_with_file, user: other).files.first }
    end
  end

  describe 'for admin' do
    let(:user) { create(:admin) }

    it { should be_able_to :manage, :all }
  end
end
