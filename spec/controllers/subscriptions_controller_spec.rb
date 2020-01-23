require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let!(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'POST #create' do
    let(:params) { { question_id: question.id, format: :js } }

    describe 'Authorized user' do
      before { login(user) }

      it 'saves a new subsciption in DB' do
        expect{ post :create, params: params }
          .to change(Subscription, :count).by(1)
      end

      it 'returns status :ok' do
        post :create, params: params

        expect(response).to have_http_status(:ok)
      end
    end

    describe 'Unauthorized user' do
      it 'does not saves a new subsciption in DB' do
        expect{ post :create, params: params }
          .to_not change(Subscription, :count)
      end

      it 'returns status :unauthorized' do
        post :create, params: params

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:params) { { question_id: question.id, format: :js } }
    let(:subscriber) { create(:user) }
    let!(:subsciption) { create(:subscription, user: subscriber, question: question) }

    describe 'Authorized subscriber' do
      before { login(subscriber) }

      it 'deletes subscription from DB' do
        expect{ delete :destroy, params: params }
          .to change(Subscription, :count).by(-1)
      end

      it 'returns status :ok' do
        delete :destroy, params: params

        expect(response).to have_http_status(:ok)
      end
    end

    describe 'Authorized not subscriber' do
      before { login(user) }

      it 'does not deletes subscription from DB' do
        expect{ delete :destroy, params: params }
          .to_not change(Subscription, :count)
      end

      it 'returns status :forbidden' do
        delete :destroy, params: params

        expect(response).to have_http_status(:forbidden)
      end
    end

    describe 'Unauthorized user' do
      it 'does not deletes subscription from DB' do
        expect{ delete :destroy, params: params }
          .to_not change(Subscription, :count)
      end

      it 'returns status :unauthorized' do
        post :create, params: params

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
