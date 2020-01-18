require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'DELETE #destroy' do
    let!(:attached_file) { question.files.attach(create_file_blob).first }
    let(:params) { { id: attached_file, format: :js } }

    describe 'Authorized author' do
      before { login(question.user) }

      it 'deletes attached file' do
        expect{ delete :destroy, params: params }
          .to change(question.files, :count).by(-1)
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
      before { login(user) }

      it 'does not deletes attached file' do
        expect{ delete :destroy, params: params }
          .to_not change(question.files, :count)
      end

      it 'does not render destroy view' do
        delete :destroy, params: params

        expect(response).to have_http_status(:forbidden)
      end

      it 'returns status :forbidden' do
        delete :destroy, params: params

        expect(response).to have_http_status(:forbidden)
      end
    end

    describe 'Unauthorized user' do
      it 'does not deletes attached file' do
        expect {
          delete :destroy, params: params
        }.to_not change(question.files, :count)
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
