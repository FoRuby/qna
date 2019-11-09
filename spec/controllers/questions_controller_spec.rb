require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do

  let(:user) { create(:user) }
  let(:user_answer_giver) { create(:user) }
  let(:question) do
    create(:question_with_answers,
      user: user,
      answers_count: 3,
      answers_author: user_answer_giver
    )
  end

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3, user: user) }
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
      before { login(user) }
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
      before { login(user) }

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

          expect(assigns(:question).user).to eq(user)
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

        it 're-rerender new view' do
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

        it 're-rerender new view' do
          post :create, params: {
            question: attributes_for(:question, :invalid_question)
          }

          expect(response).to_not render_template :new
        end
      end
    end
  end

  describe 'PATCH #update' do

    describe 'Authorized user' do
      before { login(user) }

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

        it 're-render update view' do
          patch :update, params: {
            id: question,
            question: attributes_for(:question),
            format: :js
          }

          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not change question attributes' do
          expect {
            patch :update, params: {
              id: question,
              question: attributes_for(:question, :invalid_question),
              format: :js
            }
          }.to not_change(question, :title).and not_change(question, :body)
        end

        it 're-rerender update view' do
          patch :update, params: {
            id: question,
            question: attributes_for(:question, :invalid_question),
            format: :js
          }

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
          expect {
            patch :update, params: {
              id: question,
              question: { title: 'new_title', body: 'new_body' },
              format: :js
            }
          }.to not_change(question, :title).and not_change(question, :body)
        end

        it 'does not re-render update view' do
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
          expect {
            patch :update, params: {
              id: question,
              question: attributes_for(:question, :invalid_question),
              format: :js
            }
          }.to not_change(question, :title).and not_change(question, :body)
        end

        it 'does not re-rerender update view' do
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
        user: user,
        answers_count: 3,
        answers_author: user_answer_giver
      )
    end

    describe 'Authorized user' do
      before { login(user) }

      it 'deletes question from DB' do
        expect { delete :destroy, params: { id: question } }
          .to change(Question, :count).by(-1)
      end

      it 'redirect to #index' do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to questions_path
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

