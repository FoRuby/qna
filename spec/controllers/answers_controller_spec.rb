require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  it_behaves_like 'voted'

  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer_author) { create(:user) }

  describe 'POST #create' do
    describe 'Authorized user' do
      before { login(answer_author) }

      context 'with valid attributes' do
        let(:params) do
          { question_id: question, answer: attributes_for(:answer), format: :js }
        end

        it 'save new answer in DB' do
          expect{ post :create, params: params }.to change(Answer, :count).by(1)
        end

        it 'check @answer.question is a assigned question' do
          post :create, params: params

          expect(assigns(:answer).question).to eq(question)
        end

        it 'check @answer.user is a user' do
          post :create, params: params

          expect(assigns(:answer).user).to eq(answer_author)
        end

        it 'render create' do
          post :create, params: params

          expect(response).to render_template :create
        end

        it 'returns status :ok' do
          post :create, params: params

          expect(response).to have_http_status(:ok)
        end
      end

      context 'with invalid attributes' do
        let(:params) do
          {
            question_id: question,
            answer: attributes_for(:answer, :invalid_answer),
            format: :js
          }
        end

        it 'does not save the answer' do
          expect{ post :create, params: params }.to_not change(Answer, :count)
        end

        it 'render create' do
          post :create, params: params

          expect(response).to render_template :create
        end

        it 'returns status :ok' do
          post :create, params: params

          expect(response).to have_http_status(:ok)
        end
      end
    end

    describe 'Unauthorized user' do
      context 'with valid attributes' do
        let(:params) do
          { question_id: question, answer: attributes_for(:answer), format: :js }
        end

        it 'does not save new answer in DB' do
          expect{ post :create, params: params }.to_not change(Answer, :count)
        end

        it 'does not redirect to @question' do
          post :create, params: params

          expect(response).to_not redirect_to assigns(:question)
        end

        it 'returns status :unauthorized' do
          post :create, params: params

          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'with invalid attributes' do
        let(:params) do
          {
            question_id: question,
            answer: attributes_for(:answer),
            format: :js
          }
        end
        it 'does not save the answer' do
          expect{ post :create, params: params }.to_not change(Answer, :count)
        end

        it 'does not render questions/show view' do
          post :create, params: params

          expect(response).to_not render_template :create
        end

        it 'returns status :unauthorized' do
          post :create, params: params

          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) do
      create(:answer, question: question, user: answer_author)
    end

    describe 'Authorized answer author' do
      before { login(answer_author) }

      context 'with valid attributes' do
        before do
          patch :update, params: {
            id: answer, answer: { body: 'Edited answer' },
            format: :js
          }
        end

        it 'change answer attributes' do
          expect{answer.reload}.to change(answer, :body)
        end

        it 'render update view' do
          expect(response).to render_template :update
        end

        it 'returns status :ok' do
          expect(response).to have_http_status(:ok)
        end
      end

      context 'with invalid attributes' do
        before do
          patch :update, params: {
            id: answer,
            answer: attributes_for(:answer, :invalid_answer),
            format: :js
          }
        end

        it 'does not change answer attributes' do
          expect{answer.reload}.to_not change(answer, :body)
        end

        it 'render update view' do
          expect(response).to render_template :update
        end

        it 'returns status :ok' do
          expect(response).to have_http_status(:ok)
        end
      end
    end

    describe 'Authorized not answer author' do
      before { login(user) }

      context 'with valid attributes' do
        before do
          patch :update, params: {
            id: answer,
            answer: { body: 'Edited answer' },
            format: :js
          }
        end

        it 'does not change answer attributes' do
          expect{answer.reload}.to_not change(answer, :body)
        end

        it 'does not render update view' do
          expect(response).to have_http_status(:forbidden)
        end

        it 'returns status :forbidden' do
          expect(response).to have_http_status(:forbidden)
        end
      end

      context 'with invalid attributes' do
        before do
          patch :update, params: {
            id: answer,
            answer: attributes_for(:answer, :invalid_answer),
            format: :js
          }
        end

        it 'does not change answer attributes' do
          expect{answer.reload}.to_not change(answer, :body)
        end

        it 'returns status :forbidden' do
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    describe 'Unauthorized user' do
      context 'with valid attributes' do
        before do
          patch :update, params: {
            id: answer,
            answer: { body: 'Edited answer' },
            format: :js
          }
        end

        it 'does not change answer attributes' do
          expect{answer.reload}.to_not change(answer, :body)
        end

        it 'does not render update view' do
          expect(response).to have_http_status(:unauthorized)
        end

        it 'returns status :unauthorized' do
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'with invalid attributes' do
        before do
          patch :update, params: {
            id: answer,
            answer: attributes_for(:answer, :invalid_answer),
            format: :js
          }
        end

        it 'does not change answer attributes' do
          expect{answer.reload}.to_not change(answer, :body)
        end

        it 'does not render update view' do
          expect(response).to have_http_status(:unauthorized)
        end

        it 'returns status :unauthorized' do
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end

  describe 'PATCH #mark_best' do
    let!(:answer) { create(:answer, question: question, user: answer_author) }
    let(:params) { { id: answer, format: :js } }

    describe 'Authorized question author' do
      before do
        login(question.user)
        patch :mark_best, params: params
      end

      it 'change answer best attribute' do
        expect{answer.reload}.to change(answer, :best).from(false).to(true)
      end

      it 'render mark_best view' do
        expect(response).to render_template :mark_best
      end

      it 'returns status :ok' do
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'Authorized not question author' do
      before do
        login(user)
        patch :mark_best, params: params
      end

      it 'does not change answer best attribute' do
        expect{answer.reload}.to_not change(answer, :best)
      end

      it 'does not render mark_best view' do
        expect(response).to have_http_status(:forbidden)
      end

      it 'returns status :forbidden' do
        expect(response).to have_http_status(:forbidden)
      end
    end

    describe 'Unauthorized user' do
      before do
        patch :mark_best, params: params
      end

      it 'does not change answer best attribute' do
        expect{answer.reload}.to_not change(answer, :best)
      end

      it 'does not render mark_best view' do
        expect(response).to_not render_template :mark_best
      end

      it 'returns status :unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question) }
    let(:params) { { id: answer, format: :js } }

    describe 'Authorized answer author' do
      before { login(answer.user) }

      it 'deletes answer from DB' do
        expect{ delete :destroy, params: params }
          .to change(Answer, :count).by(-1)
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

    describe 'Authorized not answer author' do
      before { login(user) }

      it 'does not deletes answer from DB' do
        expect{ delete :destroy, params: params }.to_not change(Answer, :count)
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
      it 'does not deletes answer from DB' do
        expect{ delete :destroy, params: params }.to_not change(Answer, :count)
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
