require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:author) { create(:user) }
  let(:question) { create(:question, user: author) }

  describe 'DELETE #destroy' do
    let!(:attached_file) { question.files.attach(create_file_blob).first }

    describe 'Authorized author' do
      before { login(author) }

      it 'deletes attached file' do
        expect {
          delete :destroy, params: { id: attached_file, format: :js }
        }.to change(question.files, :count).by(-1)
      end

      it 'render destroy view' do
        delete :destroy, params: { id: attached_file, format: :js }

        expect(response).to render_template :destroy
      end
    end

    describe 'Authorized not author' do
      before { login(author) }

      it 'does not deletes attached file' do
        expect {
          delete :destroy, params: { id: attached_file, format: :js }
        }.to_not change(Answer, :count)
      end

      it 'render destroy view' do
        delete :destroy, params: { id: attached_file, format: :js }

        expect(response).to render_template :destroy
      end
    end

    describe 'Unauthorized user' do
      it 'does not deletes attached file' do
        expect {
          delete :destroy, params: { id: attached_file, format: :js }
        }.to_not change(Answer, :count)
      end

      it 'does not render destroy view' do
        delete :destroy, params: { id: attached_file, format: :js }
        expect(response).to_not render_template :destroy
      end
    end
  end
end
