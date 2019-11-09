require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  describe 'POST #create' do
    describe 'Authorized user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'save new answer in DB' do
          expect {
            post :create, params: {
              question_id: question,
              answer: attributes_for(:answer),
              format: :js
            }
          }.to change(Answer, :count).by(1)
        end

        it 'check @answer.question is a assigned question' do
          post :create, params: {
            question_id: question,
            answer: attributes_for(:answer),
            format: :js
          }

          expect(assigns(:answer).question).to eq(question)
        end

        it 'check @answer.user is a user' do
          post :create, params: {
            question_id: question,
            answer: attributes_for(:answer),
            format: :js
          }

          expect(assigns(:answer).user).to eq(user)
        end

        it 'rerender create' do
          post :create, params: {
            question_id: question,
            answer: attributes_for(:answer),
            format: :js
          }

          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect {
            post :create, params: {
              question_id: question,
              answer: attributes_for(:answer, :invalid_answer),
              format: :js
            }
          }.to_not change(Answer, :count)
        end

        it 'rerender create' do
          post :create, params: {
            question_id: question,
            answer: attributes_for(:answer, :invalid_answer),
            format: :js
          }

          expect(response).to render_template :create
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

          expect(response).to_not render_template :create
        end
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer) do
      create(:answer, question: question, user: user)
    end

    describe 'Authorized user' do
      before { login(user) }

      context 'with valid attributes' do
        it 'change answer attributes' do
          patch :update, params: {
            id: answer,
            answer: { body: 'edited answer'},
            format: :js
          }

          answer.reload
          expect(answer.body).to eq 'edited answer'
        end

        it 'rerender update view' do
          patch :update, params: {
            id: answer,
            answer: { body: 'edited answer'},
            format: :js
          }

          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not change answer attributes' do
          expect {
            patch :update, params: {
              id: answer,
              answer: attributes_for(:answer, :invalid_answer),
              format: :js
            }
          }.to_not change(answer, :body)
        end

        it 're-render update view' do
          patch :update, params: {
            id: answer,
            answer: attributes_for(:answer, :invalid_answer),
            format: :js
          }

          expect(response).to render_template :update
        end
      end
    end

    describe 'Unauthorized user' do
      context 'with valid attributes' do
        it 'does not change answer attributes' do
          patch :update, params: {
            id: answer,
            answer: { body: 'new answer'},
            format: :js
          }

          expect(answer.body).to_not eq 'edited answer'
        end

        it 'does not re-render update view' do
          patch :update, params: {
            id: answer,
            answer: { body: 'edited answer'},
            format: :js
          }

          expect(response).to_not render_template :update
        end
      end

      context 'with invalid attributes' do
        it 'does not change answer attributes' do
          expect {
            patch :update, params: {
              id: answer,
              answer: attributes_for(:answer, :invalid_answer),
              format: :js
            }
          }.to_not change(answer, :body)
        end

        it 'does not re-rerender update view' do
          patch :update, params: {
            id: answer,
            answer: attributes_for(:answer, :invalid_answer),
            format: :js
          }

          expect(response).to_not render_template :update
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
        expect {
          delete :destroy, params: { id: answer, format: :js }
        }.to change(Answer, :count).by(-1)
      end

      it 're-render destroy view' do
        delete :destroy, params: { id: answer, format: :js }

        expect(response).to render_template :destroy
      end
    end

    describe 'Unauthorized user' do
      it 'does not deletes answer from DB' do
        expect {
          delete :destroy, params: { id: answer, format: :js }
        }.to_not change(Answer, :count)
      end

      it 'does not re-rerender destroy view' do
        delete :destroy, params: { id: answer, format: :js }
        expect(response).to_not render_template :destroy
      end
    end
  end
end
