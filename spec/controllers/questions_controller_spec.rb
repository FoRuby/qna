require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }
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

    it 'assign the requested question.answers to @question.answers' do
      expect(assigns(:question).answers).to eq(question.answers)
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'assign the new question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { login(user) }
    before { get :edit, params: { id: question } }

    it 'assign the requested question to @question' do
      expect(assigns(:question)).to eq(question)
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
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

  describe 'PATCH #update' do
    before { login(user) }
    context 'with valid attributes' do
      it 'assign the requested question to @question' do
        patch :update, params: {
          id: question,
          question: attributes_for(:question)
        }
        expect(assigns(:question)).to eq(question)
      end

      it 'change question attributes' do
        patch :update, params: {
          id: question,
          question: { title: 'new_title', body: 'new_body' }
        }

        question.reload
        expect(question.title).to eq 'new_title'
        expect(question.body).to eq 'new_body'
      end

      it 'redirect to updated question' do
        patch :update, params: {
          id: question,
          question: attributes_for(:question)
        }
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      before {
        patch :update, params: {
          id: question,
          question: attributes_for(:question, :invalid_question)
        }
      }

      it 'does not change question' do
        question.reload
        expect(question.title).to eq 'QuestionTitle'
        expect(question.body).to eq 'QuestionBody'
      end

      it 're-rerender edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }
    let!(:question) { create(:question) }

    it 'deletes question from DB' do
      expect { delete :destroy, params: { id: question } }
        .to change(Question, :count).by(-1)
    end

    it 'redirect to #index' do
      delete :destroy, params: { id: question }
      expect(response).to redirect_to questions_path
    end
  end
end
