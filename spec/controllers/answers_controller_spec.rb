require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'GET #new' do
    describe 'Authorized user' do
      before { login(user) }
      before { get :new, params: { question_id: question } }

      it 'assign @answer' do
        expect(assigns(:answer)).to be_a_new(Answer)
      end

      it 'render new view' do
        expect(response).to render_template :new
      end
    end

    describe 'Unauthorized user' do
      before { get :new, params: { question_id: question } }

      it 'does not assign @answer' do
        expect(assigns(:answer)).to be nil
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
        it 'save new answer in DB' do
          expect {
            post :create, params: {
              question_id: question,
              answer: attributes_for(:answer)
            }
          }.to change(Answer, :count).by(1)
        end

        it 'check @answer.question is a assigned question' do
          post :create, params: {
            question_id: question,
            answer: attributes_for(:answer)
          }

          expect(assigns(:answer).question).to eq(question)
        end

        it 'check @answer.user is a user' do
          post :create, params: {
            question_id: question,
            answer: attributes_for(:answer)
          }

          expect(assigns(:answer).user).to eq(user)
        end

        it 'redirect to @question' do
          post :create, params: {
            question_id: question,
            answer: attributes_for(:answer)
          }

          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect {
            post :create, params: {
              question_id: question,
              answer: attributes_for(:answer, :invalid_answer)
            }
          }.to_not change(Answer, :count)
        end

        it 're-rerender questions/show view' do
          post :create, params: {
            question_id: question,
            answer: attributes_for(:answer, :invalid_answer)
          }

          expect(response).to render_template 'questions/show'
        end
      end
    end

    describe 'Unauthorized user' do
      context 'with valid attributes' do
        it 'does not save new answer in DB' do
          expect {
            post :create, params: {
              question_id: question,
              answer: attributes_for(:answer)
            }
          }.to_not change(Answer, :count)
        end

        it 'does not redirect to @question' do
          post :create, params: {
            question_id: question,
            answer: attributes_for(:answer)
          }

          expect(response).to_not redirect_to assigns(:question)
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect {
            post :create, params: {
              question_id: question,
              answer: attributes_for(:answer, :invalid_answer)
            }
          }.to_not change(Answer, :count)
        end

        it 'does not re-rerender questions/show view' do
          post :create, params: {
            question_id: question,
            answer: attributes_for(:answer, :invalid_answer)
          }

          expect(response).to_not render_template 'questions/show'
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) do
      create(:answer, question: question, user: user)
    end

    describe 'Authorized user' do
      before { login(user) }

      it 'deletes answer from DB' do
        expect { delete :destroy, params: { id: answer } }
          .to change(Answer, :count).by(-1)
      end

      it 'redirect to questions#show' do
        delete :destroy, params: { id: answer }

        expect(response).to redirect_to question_path(question)
      end
    end

    describe 'Unauthorized user' do
      it 'does not deletes answer from DB' do
        expect { delete :destroy, params: { id: answer } }
          .to_not change(Answer, :count)
      end

      it 'does not redirect to questions#show' do
        delete :destroy, params: { id: answer }

        expect(response).to_not redirect_to question_path(question)
      end
    end
  end
end

