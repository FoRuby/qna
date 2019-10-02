require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
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

    it 'assign @question' do
      expect(assigns(:question)).to eq(question)
    end

    context 'with valid attributes' do

      it 'save new answer in DB' do
        expect {
          post :create, params: {
            question_id: question,
            answer: attributes_for(:answer)
          }
        }.to change(Answer, :count).by(1)
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

      it 're-rerender new view' do
        post :create, params: {
          question_id: question,
          answer: attributes_for(:answer, :invalid_answer)
        }
        expect(response).to render_template :new
      end
    end
  end
end
