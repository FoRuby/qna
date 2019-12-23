require 'rails_helper'

RSpec.describe FindForOauthService do
  let!(:user) { create(:user) }
  let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }

  describe 'user already exist' do
    subject { FindForOauthService.new(auth, user.email) }

    context 'user exist by email' do
      it 'returns user by email' do
        expect(subject.call).to eq user
      end

      it 'does not create new user' do
        expect { subject.call }.to_not change(User, :count)
      end

      it 'create new authorization' do
        expect { subject.call }.to change(user.authorizations, :count)
      end
    end

    context 'user has authorization' do
      let!(:authorization) do
        create(:authorization, user: user, provider: 'facebook', uid: '123456')
      end

      it 'does not create new user' do
        expect { subject.call }.to_not change(User, :count)
      end

      it 'does not create new authorization' do
        expect { subject.call }.to_not change(Authorization, :count)
      end

      it 'returns the user' do
        expect(subject.call).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exists' do
        it 'does not create new user' do
          expect { subject.call }.to_not change(User, :count)
        end

        it 'create authorization for new user' do
          expect { subject.call }.to change(user.authorizations, :count).by(1)
        end

        it 'returns the user' do
          expect(subject.call).to eq user
        end
      end
    end
  end

  describe 'user does not exist' do
    subject { FindForOauthService.new(auth, 'user@example.ru') }

    it 'creates new user' do
      expect { subject.call }.to change(User, :count).by(1)
    end

    it 'create authorization for new user' do
      expect { subject.call }.to change(Authorization, :count).by(1)
      expect(subject.call.email).to eq 'user@example.ru'
    end

    it 'returns new user' do
      expect(subject.call).to eq User.find_by(email: 'user@example.ru')
    end
  end
end
