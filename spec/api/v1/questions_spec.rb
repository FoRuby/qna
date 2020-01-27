require 'rails_helper'

describe 'Question API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    let(:method) { :get }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let(:params) { { access_token: access_token.token } }

      before { do_request(method, api_path, params: params, headers: headers) }

      it_behaves_like 'Successful request'

      it_behaves_like 'Public fields' do
        let(:attributes) { %w[id title body created_at updated_at] }
        let(:resource_response) { question_response }
        let(:resource) { question }
      end

      it_behaves_like 'List' do
        let(:resource_response) { json['questions'] }
        let(:resource) { questions }
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it_behaves_like 'Public fields' do
          let(:attributes) { %w[id body best question_id created_at updated_at] }
          let(:resource_response) { answer_response }
          let(:resource) { answer }
        end

        it_behaves_like 'List' do
          let(:resource_response) { question_response['answers'] }
          let(:resource) { answers }
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let!(:question) { create(:question) }
    let!(:comments) { create_list(:comment, 2, commentable: question) }
    let!(:links) { create_list(:link, 2, linkable: question) }
    let(:method) { :get }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }
      let(:params) { { access_token: access_token.token } }

      before { do_request(method, api_path, params: params, headers: headers) }

      it_behaves_like 'Successful request'

      it_behaves_like 'Public fields' do
        let(:attributes) { %w[id title body user_id created_at updated_at] }
        let(:resource_response) { question_response }
        let(:resource) { question }
      end

      describe 'comments' do
        it_behaves_like 'List' do
          let(:resource_response) { question_response['comments'] }
          let(:resource) { comments }
        end
      end

      describe 'links' do
        it_behaves_like 'List' do
          let(:resource_response) { question_response['links'] }
          let(:resource) { links }
        end
      end

      describe 'files' do
        it_behaves_like 'List' do
          let(:resource_response) { question_response['files'] }
          let(:resource) { question.files }
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:method) { :post }
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      context 'with valid attributes' do
        let(:params) do
          {
            question: attributes_for(:question),
            access_token: access_token.token
          }
        end

        it 'saves a new question in database' do
          expect{
            do_request(method, api_path, params: params, headers: headers)
          }.to change(Question, :count).by(1)
        end

        it 'returns status :created' do
          do_request(method, api_path, params: params, headers: headers)

          expect(response).to have_http_status(:created)
        end
      end

      context 'with invalid attributes' do
        let(:params) do
          {
            question: attributes_for(:question, :invalid_question),
            access_token: access_token.token
          }
        end

        it 'does not save the question' do
          expect {
            do_request(method, api_path, params: params, headers: headers)
          }.to_not change(Question, :count)
        end

        it 'returns status :unprocessable_entity' do
          do_request(method, api_path, params: params, headers: headers)

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns error message' do
          do_request(method, api_path, params: params, headers: headers)

          expect(json['errors']).to be
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:method) { :patch }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      context 'with valid attributes' do
        let(:params) do
          {
            question: { title: 'Edited title', body: 'Edited body' },
            access_token: access_token.token
          }
        end

        before { do_request(method, api_path, params: params, headers: headers) }

        it_behaves_like 'Successful request'

        it 'changes question attributes' do
          expect{question.reload}.to change(question, :title).to('Edited title')
            .and change(question, :body).to('Edited body')
        end
      end

      context 'with invalid attributes' do
        let(:params) do
          {
            question: attributes_for(:question, :invalid_question),
            access_token: access_token.token
          }
        end

        before { do_request(method, api_path, params: params, headers: headers) }

        it 'does not change attributes of question' do
          expect{ question.reload }.to not_change(question, :title)
            .and not_change(question, :body)
        end

        it 'returns status :unprocessable_entity' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns error message' do
          expect(json['errors']).to be
        end
      end
    end

    context 'not question author tries to update question' do
      let(:params) do
        {
          question: { title: 'Edited title', body: 'Edited body' },
          access_token: create(:access_token).token
        }
      end

      before { do_request(method, api_path, params: params, headers: headers) }

      it 'returns status :forbidden' do
        expect(response).to have_http_status(:forbidden)
      end

      it 'does not change question attributes' do
        expect{ question.reload }.to not_change(question, :title)
          .and not_change(question, :body)
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:method) { :delete }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:params) { { access_token: access_token.token } }

      context 'delete question' do
        it 'returns status :ok' do
          do_request(method, api_path, params: params, headers: headers)

          expect(response).to have_http_status(:ok)
        end

        it 'deletes question from DB' do
          expect{
            do_request(method, api_path, params: params, headers: headers)
          }.to change{Question.count}.by(-1)
        end

        it 'returns json message' do
          do_request(method, api_path, params: params, headers: headers)

          expect(json['messages']).to include 'Question was successfully deleted.'
        end
      end
    end

    context 'not question author tries to delete question' do
      let(:params) { { access_token: create(:access_token).token } }

      it 'returns status :forbidden' do
        do_request(method, api_path, params: params, headers: headers)

        expect(response).to have_http_status(:forbidden)
      end

      it 'does not deletes question from DB' do
        expect{
          do_request(method, api_path, params: params, headers: headers)
        }.to_not change{Question.count}
      end
    end
  end
end
