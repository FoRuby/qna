require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  it_behaves_like 'voted'

  let(:user) { create(:user) }
  let(:question_author) { create(:user) }
  let(:question) { create(:question) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'show an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index view' do
      expect(response).to render_template :index
    end

    it 'returns status :ok' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'assign the requested question to @question' do
      expect(assigns(:question)).to eq(question)
    end

    it 'render show view' do
      expect(response).to render_template :show
    end

    it 'assign the new answer to @question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'assign the new Link to @answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end

    it 'returns status :ok' do
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #new' do
    describe 'Authorized user' do
      before do
        login(question.user)
        get :new
      end

      it 'assign the new question to @question' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'assign the new Link to @question' do
        expect(assigns(:question).links.first).to be_a_new(Link)
      end

      it 'render new view' do
        expect(response).to render_template :new
      end

      it 'returns status :ok' do
        expect(response).to have_http_status(:ok)
      end
    end

    describe 'Unauthorized user' do
      before { get :new }

      it 'does not assign the new question to @question' do
        expect(assigns(:question)).to be_nil
      end

      it 'does not render new view' do
        expect(response).to_not render_template :new
      end

      it 'returns status :redirect' do
        expect(response).to have_http_status(:redirect)
      end
    end
  end

  describe 'POST #create' do
    describe 'Authorized user' do
      before { login(question_author) }

      context 'with valid attributes' do
        let(:params) { { question: attributes_for(:question), format: :js } }

        it 'saves a new question in the database' do
          expect{ post :create,params: params }.to change(Question, :count).by(1)
        end

        it 'redirect to show view' do
          post :create, params: params

          expect(response).to redirect_to assigns(:question)
        end

        it 'check @question.user is a assigned user' do
          post :create, params: params

          expect(assigns(:question).user).to eq(question_author)
        end

        it 'returns status :redirect' do
          post :create, params: params

          expect(response).to have_http_status(:redirect)
        end
      end

      context 'with invalid attributes' do
        let(:params) do
          { question: attributes_for(:question, :invalid_answer), format: :js }
        end

        it 'does not save the question' do
          expect { post :create, params: params }.to_not change(Question, :count)
        end

        it 'render new view' do
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
        let(:params) { { question: attributes_for(:question), format: :js } }

        it 'does not saves a new question in the database' do
          expect{ post :create, params: params }.to_not change(Question, :count)
        end

        it 'does not redirect to show view' do
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
          { question: attributes_for(:question, :invalid_question) }
        end

        it 'does not save the question' do
          expect{ post :create, params: params }.to_not change(Question, :count)
        end

        it 'does not render new view' do
          post :create, params: params

          expect(response).to_not render_template :new
        end

        it 'returns status :redirect' do
          post :create, params: params

          expect(response).to have_http_status(:redirect)
        end
      end
    end
  end

  describe 'PATCH #update' do
    describe 'Authorized question author' do
      before { login(question.user) }

      context 'with valid attributes' do
        before do
          patch :update, params: {
            id: question,
            question: { title: 'Edited title', body: 'Edited body' },
            format: :js
          }
        end

        it 'assign the requested question to @question' do
          expect(assigns(:question)).to eq(question)
        end

        it 'change question attributes' do
          expect{question.reload}.to change(question, :title)
            .and change(question, :body)
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
            id: question,
            question: attributes_for(:question, :invalid_question),
            format: :js
          }
        end

        it 'does not change question attributes' do
          expect{question.reload}.to not_change(question, :title)
            .and not_change(question, :body)
        end

        it 'render update view' do
          expect(response).to render_template :update
        end

        it 'returns status :ok' do
          expect(response).to have_http_status(:ok)
        end
      end
    end

    describe 'Authorized not question author' do
      before { login(user) }

      context 'with valid attributes' do
        before do
          patch :update, params: {
            id: question,
            question: { title: 'Edited title', body: 'Edited body' },
            format: :js
          }
        end

        it 'assign the requested question to @question' do
          expect(assigns(:question)).to eq(question)
        end

        it 'does not change question attributes' do
          expect{question.reload}.to not_change(question, :title)
            .and not_change(question, :body)
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
            id: question,
            question: attributes_for(:question, :invalid_question),
            format: :js
          }
        end

        it 'does not change question attributes' do
          expect{question.reload}.to not_change(question, :title)
            .and not_change(question, :body)
        end

        it 'does not render update view' do
          expect(response).to have_http_status(:forbidden)
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
            id: question,
            question: { title: 'Edited title', body: 'Edited body' },
            format: :js
          }
        end

        it 'does not assign the requested question to @question' do
          expect(assigns(:question)).to_not eq(question)
        end

        it 'does not change question attributes' do
          expect{question.reload}.to not_change(question, :title)
            .and not_change(question, :body)
        end

        it 'does not render update view' do
          expect(response).to_not render_template :update
        end

        it 'returns status :unauthorized' do
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'with invalid attributes' do
        before do
          patch :update, params: {
            id: question,
            question: attributes_for(:question, :invalid_question),
            format: :js
          }
        end

        it 'does not change question' do
          expect{question.reload}.to not_change(question, :title)
            .and not_change(question, :body)
        end

        it 'does not render update view' do
          expect(response).to_not render_template :update
        end

        it 'returns status :unauthorized' do
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question_with_answers, answers_count: 2) }

    describe 'Authorized question author' do
      before { login(question.user) }

      it 'deletes question from DB' do
        expect{ delete :destroy, params: { id: question } }
          .to change(Question, :count).by(-1)
      end

      it 'deletes question answers from DB' do
        expect { delete :destroy, params: { id: question } }
          .to change(Answer, :count).by(-2)
      end

      it 'redirect to #index' do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to questions_path
      end

      it 'returns status :redirect' do
        delete :destroy, params: { id: question }

        expect(response).to have_http_status(:redirect)
      end
    end

    describe 'Authorized not question author' do
      before { login(user) }

      it 'does not deletes question from DB' do
        expect{ delete :destroy, params: { id: question } }
          .to_not change(Question, :count)
      end

      it 'does not redirect to #index' do
        delete :destroy, params: { id: question }

        expect(response).to_not redirect_to questions_path
      end
    end

    describe 'Unauthorized user' do
      it 'does not deletes question from DB' do
        expect{ delete :destroy, params: { id: question } }
          .to_not change(Question, :count)
      end

      it 'does not deletes question answers from DB' do
        expect{ delete :destroy, params: { id: question } }
          .to_not change(Answer, :count)
      end

      it 'does not redirect to #index' do
        delete :destroy, params: { id: question }

        expect(response).to_not redirect_to questions_path
      end
    end
  end
end
