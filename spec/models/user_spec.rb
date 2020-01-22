require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'associations' do
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:questions).dependent(:destroy) }
    it { should have_many(:rewards).dependent(:destroy) }
    it { should have_many(:comments).dependent(:destroy) }
    it { should have_many(:authorizations).dependent(:destroy) }
    it { should have_many(:subscriptions).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }

    it { should validate_length_of(:password).is_at_least(6) }
    it { should have_db_index(:email).unique(:true) }
  end

  describe '#author_of?(item)' do
    let(:author) { create(:user) }
    let(:not_author) { create(:user) }
    let(:question) { create(:question, user: author) }
    let(:item_without_author) { Class.new }

    context 'author' do
      subject { author }
        it { is_expected.to be_an_author_of(question) }
        it { is_expected.to_not be_an_author_of(item_without_author) }
    end

    context 'not_author' do
      subject { not_author }
        it { is_expected.to_not be_an_author_of(question) }
        it { is_expected.to_not be_an_author_of(item_without_author) }
    end
  end

  describe '#subscribed_on?(question)' do
    let(:question) { create(:question) }
    let(:subscriber) { create(:user) }
    let(:not_subscriber) { create(:user) }
    let!(:subscription) { create(:subscription, user: subscriber, question: question) }

    context 'subscriber' do
      subject { subscriber }
        it { is_expected.to be_an_subscribed_on(question) }
    end

    context 'not subscriber' do
      subject { not_subscriber }
        it { is_expected.to_not be_an_subscribed_on(question) }
    end
  end

  describe '.find_for_oauth(auth, email)' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123') }
    let(:service) { double('FindForOauthService') }

    it 'calls FindForOauthService' do
      expect(FindForOauthService).to receive(:new).with(auth, user.email)
        .and_return(service)
      expect(service).to receive(:call)

      User.find_for_oauth(auth, user.email)
    end
  end

  describe '.find_or_create!(email)' do
    context 'User with current email exist' do
      let!(:user) { create(:user, email: 'existing@email.com') }

      subject { User.find_or_create!('existing@email.com') }
      it { is_expected.to eq user }
    end

    context 'User with current email does not exist' do
      it 'creates new user' do
        expect{ User.find_or_create!('new_user@email.com') }
          .to change(User, :count).by(1)
      end

      it 'creates user with current email' do
        expect(User.create_user_with_rand_password!('new_user@email.com'))
          .to eq User.find_by(email: 'new_user@email.com')
      end
    end
  end

  describe '.create_user_with_rand_password!(email)' do
    it 'creates new user' do
      expect{ User.find_or_create!('new_user@email.com') }
        .to change(User, :count).by(1)
    end

    it 'creates user with current email' do
      expect(User.create_user_with_rand_password!('new_user@email.com'))
        .to eq User.find_by(email: 'new_user@email.com')
    end
  end
end
