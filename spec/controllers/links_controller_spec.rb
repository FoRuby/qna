require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:question) { create(:question) }

  describe 'DELETE #destroy' do
    let!(:link) { create(:link, linkable: question) }
    let(:params) { { id: link, format: :js } }

    describe 'Authorized author' do
      before { login(question.user) }

      it 'deletes link' do
        expect{ delete :destroy, params: params }.to change(Link, :count).by(-1)
      end

      it 'render destroy view' do
        delete :destroy, params: params

        expect(response).to render_template :destroy
      end

      it 'returns status :ok' do
        delete :destroy, params: params

        expect(response).to have_http_status(:ok)
      end
    end

    describe 'Authorized not author' do
      let(:user) { create(:user) }
      before { login(user) }

      it 'does not deletes link' do
        expect{ delete :destroy, params: params }.to_not change(Link, :count)
      end

      it 'render destroy view' do
        delete :destroy, params: params

        expect(response).to render_template :destroy
      end

      it 'returns status :forbidden' do
        delete :destroy, params: params

        expect(response).to have_http_status(:forbidden)
      end
    end

    describe 'Unauthorized user' do
      it 'does not deletes link' do
        expect{ delete :destroy, params: params }
          .to_not change(question.links, :count)
      end

      it 'does not render destroy view' do
        delete :destroy, params: params

        expect(response).to_not render_template :destroy
      end

      it 'returns status :unauthorized' do
        delete :destroy, params: params

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
