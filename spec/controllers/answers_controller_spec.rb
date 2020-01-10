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

          expect(assigns(:answer).user).to eq(answer_author)
        end

        it 'render create' do
          post :create, params: {
            question_id: question,
            answer: attributes_for(:answer),
            format: :js
          }

          expect(response).to render_template :create
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect {
            post :create, params: {
              question_id: question,
              answer: attributes_for(:answer, :invalid_answer),
              format: :js
            }
          }.to_not change(Answer, :count)
        end

        it 'render create' do
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
        it 'does not save the answer' do
          expect {
            post :create, params: {
              question_id: question,
              answer: attributes_for(:answer, :invalid_answer)
            }
          }.to_not change(Answer, :count)
        end

        it 'does not render questions/show view' do
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
      create(:answer, question: question, user: answer_author)
    end

    describe 'Authorized answer author' do
      before { login(answer_author) }

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

        it 'render update view' do
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
          patch :update, params: {
            id: answer,
            answer: attributes_for(:answer, :invalid_answer),
            format: :js
          }
          expect{ answer.reload }.to_not change(answer, :body)
        end

        it 'render update view' do
          patch :update, params: {
            id: answer,
            answer: attributes_for(:answer, :invalid_answer),
            format: :js
          }

          expect(response).to render_template :update
        end
      end
    end

    describe 'Authorized not answer author' do
      before { login(user) }

      context 'with valid attributes' do
        it 'does not change answer attributes' do
          patch :update, params: {
            id: answer,
            answer: { body: 'edited answer'},
            format: :js
          }

          answer.reload
          expect(answer.body).to_not eq 'edited answer'
        end

        it 'does not render update view' do
          patch :update, params: {
            id: answer,
            answer: { body: 'edited answer'},
            format: :js
          }

          expect(response).to have_http_status(:forbidden)
        end
      end

      context 'with invalid attributes' do
        it 'does not change answer attributes' do
          patch :update, params: {
            id: answer,
            answer: attributes_for(:answer, :invalid_answer),
            format: :js
          }
          expect{ answer.reload }.to_not change(answer, :body)
        end

        it 'does not render update view' do
          patch :update, params: {
            id: answer,
            answer: attributes_for(:answer, :invalid_answer),
            format: :js
          }

          expect(response).to have_http_status(:forbidden)
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
          answer.reload

          expect(answer.body).to_not eq 'edited answer'
        end

        it 'does not render update view' do
          patch :update, params: {
            id: answer,
            answer: { body: 'edited answer'},
            format: :js
          }

          expect(response).to have_http_status(:unauthorized)
        end
      end

      context 'with invalid attributes' do
        it 'does not change answer attributes' do
          patch :update, params: {
            id: answer,
            answer: attributes_for(:answer, :invalid_answer),
            format: :js
          }
          expect { answer.reload }.to_not change(answer, :body)
        end

        it 'does not render update view' do
          patch :update, params: {
            id: answer,
            answer: attributes_for(:answer, :invalid_answer),
            format: :js
          }

          expect(response).to have_http_status(:unauthorized)
        end
      end
    end
  end

  describe 'PATCH #mark_best' do
    let!(:answer) { create(:answer, question: question, user: answer_author) }

    describe 'Authorized question author' do
      before do
        login(question.user)
        patch :mark_best, params: {
          id: answer,
          format: :js
        }
        answer.reload
      end

      context 'answer best attribute' do
        subject { answer.best }
        it { is_expected.to be_truthy }
      end

      it 'render mark_best view' do
        expect(response).to render_template :mark_best
      end
    end

    describe 'Authorized not question author' do
      before do
        login(user)
        patch :mark_best, params: {
          id: answer,
          format: :js
        }
      end

      it 'does not change answer best attribute' do
        expect{ answer.reload }.to_not change{answer.best}
      end

      it 'does not render mark_best view' do
        expect(response).to have_http_status(:forbidden)
      end
    end

    describe 'Unauthorized user' do
      before do
        patch :mark_best, params: {
          id: answer,
          format: :js
        }
        answer.reload
      end

      it 'does not change answer best attribute' do
        expect{ answer.reload }.to_not change{answer.best}
      end

      it 'does not render mark_best view' do
        expect(response).to_not render_template :mark_best
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { create(:answer, question: question) }

    describe 'Authorized answer author' do
      before { login(answer.user) }

      it 'deletes answer from DB' do
        expect {
          delete :destroy, params: { id: answer, format: :js }
        }.to change(Answer, :count).by(-1)
      end

      it 'render destroy view' do
        delete :destroy, params: { id: answer, format: :js }

        expect(response).to render_template :destroy
      end
    end

    describe 'Authorized not answer author' do
      before { login(user) }

      it 'does not deletes answer from DB' do
        expect {
          delete :destroy, params: { id: answer, format: :js }
        }.to_not change(Answer, :count)
      end

      it 'does not render destroy view' do
        delete :destroy, params: { id: answer, format: :js }

        expect(response).to have_http_status(:forbidden)
      end
    end

    describe 'Unauthorized user' do
      it 'does not deletes answer from DB' do
        expect {
          delete :destroy, params: { id: answer, format: :js }
        }.to_not change(Answer, :count)
      end

      it 'does not render destroy view' do
        delete :destroy, params: { id: answer, format: :js }
        expect(response).to_not render_template :destroy
      end
    end
  end
end
