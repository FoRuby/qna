require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }

  describe 'DELETE #destroy' do
    let!(:link) { create(:link, linkable: question) }

    describe 'Authorized author' do
      before { login(question.user) }

      it 'deletes link' do
        expect {
          delete :destroy, params: { id: link, format: :js }
        }.to change(Link, :count).by(-1)
      end

      it 'render destroy view' do
        delete :destroy, params: { id: link, format: :js }

        expect(response).to render_template :destroy
      end
    end

    describe 'Authorized not author' do
      before { login(user) }

      it 'does not deletes link' do
        expect {
          delete :destroy, params: { id: link, format: :js }
        }.to_not change(Link, :count)
      end

      it 'render destroy view' do
        delete :destroy, params: { id: link, format: :js }

        expect(response).to render_template :destroy
      end
    end

    describe 'Unauthorized user' do
      it 'does not deletes link' do
        expect {
          delete :destroy, params: { id: link, format: :js }
        }.to_not change(question.files, :count)
      end

      it 'does not render destroy view' do
        delete :destroy, params: { id: link, format: :js }
        expect(response).to_not render_template :destroy
      end

      it 'returns 401 Unauthorized status code' do
        delete :destroy, params: { id: link, format: :js }
        expect(response).to have_http_status(401)
      end
    end
  end
end
