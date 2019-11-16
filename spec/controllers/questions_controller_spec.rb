require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  let(:question_author) { create(:user) }
  let(:answer_author) { create(:user) }
  let(:question) do
    create(:question_with_answers,
      user: question_author,
      answers_count: 3,
      answers_author: answer_author
    )
  end

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, user: question_author) }
    before { get :index }

    it 'show an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'render index view' do
      expect(response).to render_template :index
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
  end

  describe 'GET #new' do

    describe 'Authorized user' do
      before { login(question_author) }
      before { get :new }

      it 'assign the new question to @question' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'render new view' do
        expect(response).to render_template :new
      end
    end

    describe 'Unauthorized user' do
      before { get :new }

      it 'does not assign the new question to @question' do
        expect(assigns(:question)).to be nil
      end

      it 'does not render new view' do
        expect(response).to_not render_template :new
      end
    end
  end

  describe 'POST #create' do
    describe 'Authorized user' do
      before { login(question_author) }

      context 'with valid attributes' do
        it 'saves a new question in the database' do
          expect { post :create, params: { question: attributes_for(:question) } }
            .to change(Question, :count).by(1)
        end

        it 'redirect to show view' do
          post :create, params: { question: attributes_for(:question) }

          expect(response).to redirect_to assigns(:question)
        end

        it 'check @question.user is a assigned user' do
          post :create, params: { question: attributes_for(:question) }

          expect(assigns(:question).user).to eq(question_author)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect {
            post :create, params: {
              question: attributes_for(:question, :invalid_question)
            }
          }.to_not change(Question, :count)
        end

        it 'render new view' do
          post :create, params: {
            question: attributes_for(:question, :invalid_question)
          }

          expect(response).to render_template :new
        end
      end
    end

    describe 'Unauthorized user' do
      context 'with valid attributes' do
        it 'does not saves a new question in the database' do
          expect { post :create, params: { question: attributes_for(:question) } }
            .to_not change(Question, :count)
        end

        it 'does not redirect to show view' do
          post :create, params: { question: attributes_for(:question) }

          expect(response).to_not redirect_to assigns(:question)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect {
            post :create, params: {
              question: attributes_for(:question, :invalid_question)
            }
          }.to_not change(Question, :count)
        end

        it 'render new view' do
          post :create, params: {
            question: attributes_for(:question, :invalid_question)
          }

          expect(response).to_not render_template :new
        end
      end
    end
  end

  describe 'PATCH #update' do

    describe 'Authorized question author' do
      before { login(question_author) }

      context 'with valid attributes' do
        let(:new_question_title){ 'new_title' }
        let(:new_question_body){ 'new_body' }

        it 'assign the requested question to @question' do
          patch :update, params: {
            id: question,
            question: attributes_for(:question),
            format: :js
          }

          expect(assigns(:question)).to eq(question)
        end

        it 'change question attributes' do
          patch :update, params: {
            id: question,
            question: { title: new_question_title, body: new_question_body },
            format: :js
          }

          question.reload
          expect(question.title).to eq new_question_title
          expect(question.body).to eq new_question_body
        end

        it 'render update view' do
          patch :update, params: {
            id: question,
            question: attributes_for(:question),
            format: :js
          }

          expect(response).to render_template :update
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
          expect { question.reload }.to not_change(question, :title)
            .and not_change(question, :body)
        end

        it 'render update view' do
          expect(response).to render_template :update
        end
      end
    end

    describe 'Authorized not question author' do
      before { login(answer_author) }

      context 'with valid attributes' do
        let(:new_question_title){ 'new_title' }
        let(:new_question_body){ 'new_body' }

        it 'assign the requested question to @question' do
          patch :update, params: {
            id: question,
            question: attributes_for(:question),
            format: :js
          }

          expect(assigns(:question)).to eq(question)
        end

        it 'does not change question attributes' do
          patch :update, params: {
            id: question,
            question: { title: new_question_title, body: new_question_body },
            format: :js
          }

          question.reload
          expect(question.title).to_not eq new_question_title
          expect(question.body).to_not eq new_question_body
        end

        it 'render update view' do
          patch :update, params: {
            id: question,
            question: attributes_for(:question),
            format: :js
          }

          expect(response).to render_template :update
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
          expect { question.reload }.to not_change(question, :title)
            .and not_change(question, :body)
        end

        it 'render update view' do
          expect(response).to render_template :update
        end
      end
    end

    describe 'Unauthorized user' do
      context 'with valid attributes' do
        it 'does not assign the requested question to @question' do
          patch :update, params: {
            id: question,
            question: attributes_for(:question),
            format: :js
          }

          expect(assigns(:question)).to_not eq(question)
        end

        it 'does not change question attributes' do
          patch :update, params: {
            id: question,
            question: { title: 'new_title', body: 'new_body' },
            format: :js
          }
          expect { question.reload }.to not_change(question, :title)
            .and not_change(question, :body)
        end

        it 'does not render update view' do
          patch :update, params: {
            id: question,
            question: attributes_for(:question),
            format: :js
          }

          expect(response).to_not render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not change question' do
          patch :update, params: {
            id: question,
            question: attributes_for(:question, :invalid_question),
            format: :js
          }
          expect { question.reload }.to not_change(question, :title)
            .and not_change(question, :body)
        end

        it 'does not render update view' do
          patch :update, params: {
            id: question,
            question: attributes_for(:question, :invalid_question),
            format: :js
          }

          expect(response).to_not render_template :update
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) do
      create(:question_with_answers,
        user: question_author,
        answers_count: 3,
        answers_author: answer_author
      )
    end

    describe 'Authorized question author' do
      before { login(question_author) }

      it 'deletes question from DB' do
        expect { delete :destroy, params: { id: question } }
          .to change(Question, :count).by(-1)
      end

      it 'redirect to #index' do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to questions_path
      end
    end

    describe 'Authorized user' do
      before { login(answer_author) }

      it 'does not deletes question from DB' do
        expect { delete :destroy, params: { id: question } }
          .to_not change(Question, :count)
      end

      it 'does not redirect to #index' do
        delete :destroy, params: { id: question }

        expect(response).to_not redirect_to questions_path
      end
    end

    describe 'Unauthorized user' do
      it 'does not deletes question from DB' do
        expect { delete :destroy, params: { id: question } }
          .to_not change(Question, :count)
      end

      it 'does not deletes question answers from DB' do
        expect { delete :destroy, params: { id: question } }
          .to_not change(Answer, :count)
      end

      it 'does not redirect to #index' do
        delete :destroy, params: { id: question }
        expect(response).to_not redirect_to questions_path
      end
    end
  end
end
