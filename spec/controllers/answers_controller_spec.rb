require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }
  before { login(user) }
  before { get :new, params: { question_id: question } }

  describe 'GET #new' do
    it 'assign @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
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

      it 'check @answer.author is a user' do
        post :create, params: {
          question_id: question,
          answer: attributes_for(:answer)
        }
        expect(assigns(:answer).author).to eq(user)
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

  describe 'DELETE #destroy' do
    before { login(user) }
    let!(:answer) do
      FactoryBot.create(:answer_with_index, question: question, author: user)
    end

    it 'deletes answer from DB' do
      expect { delete :destroy, params: { id: answer } }
        .to change(Answer, :count).by(-1)
    end

    it 'redirect to questions#show' do
      delete :destroy, params: { id: answer }
      expect(response).to redirect_to question_path(question)
    end
  end
end
