require 'rails_helper'

describe 'Question API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }

      before do
        do_request(:get, api_path, params: { access_token: access_token.token }, headers: headers)
      end

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
          let(:attributes) { %w[id body user_id best created_at updated_at] }
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
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }
      let(:params) { { access_token: access_token.token } }

      before do
        do_request(:get, api_path, params: params, headers: headers)
      end

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
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:params) { { access_token: access_token.token } }

      before do
        do_request(:get, api_path, params: params, headers: headers)
      end

      context 'with valid attributes' do
        it 'saves a new question in database' do
          expect {
            post api_path,
            params: {
              question: attributes_for(:question),
              access_token:access_token.token
            }
          }.to change(Question, :count).by(1)
        end

        it 'returns status :created' do
          post api_path, params: {
            question: attributes_for(:question),
            access_token: access_token.token
          }

          expect(response.status).to eq 201
        end
      end

      context 'with invalid attributes' do
        it 'does not save the question' do
          expect {
            post api_path,
            params: {
              question: attributes_for(:question, :invalid_question),
              access_token: access_token.token
            }
          }.to_not change(Question, :count)
        end

        it 'returns status :unprocessible_entity' do
          post api_path, params: {
            question: attributes_for(:question, :invalid_question),
            access_token: access_token.token
          }

          expect(response.status).to eq 422
        end

        it 'returns error message' do
          post api_path, params: {
            question: attributes_for(:question, :invalid_question),
            access_token: access_token.token
          }

          expect(json['errors']).to be
        end
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      context 'with valid attributes' do
        before do
          patch api_path, params: {
            id: question,
            question: { title: 'New question title', body: 'New question body' },
            access_token: access_token.token
          }
        end

        it_behaves_like 'Successful request'

        it 'changes question attributes' do
          question.reload

          expect(question.title).to eq 'New question title'
          expect(question.body).to eq 'New question body'
        end

        it 'returns status :created' do
          expect(response.status).to eq 201
        end
      end

      context 'with invalid attributes' do
        before do
          patch api_path, params: {
            id: question,
            question: { title: '', body: '' },
            access_token: access_token.token }
        end

        it 'does not change attributes of question' do
          expect { question.reload }.to not_change(question, :title)
            .and not_change(question, :body)
        end

        it 'returns status :unprocessible_entity' do
          expect(response.status).to eq 422
        end

        it 'returns error message' do
          expect(json['errors']).to be
        end
      end
    end

    context 'not question author tries to update question' do
      let(:other_user) { create(:user) }
      let(:other_question) { create(:question, user: other_user) }
      let(:other_api_path) { "/api/v1/questions/#{other_question.id}" }

      before do
        patch other_api_path, params: {
          id: other_question,
          question: { title: 'New question title', body: 'New question body' },
          access_token: access_token.token }
      end

      it 'returns status 302' do
        expect(response.status).to eq 302
      end

      it 'does not change question attributes' do
        other_question.reload

        expect(other_question.title).to_not eq 'New question title'
        expect(other_question.body).to_not eq 'New question body'
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      context 'delete question' do
        let(:params) { { access_token: access_token.token, id: "#{question.id}" } }

        before do
          do_request(:delete, api_path, params: params, headers: headers)
        end

        it_behaves_like 'Successful request'

        it 'deletes question from the DB' do
          expect(Question.count).to eq 0
        end

        it 'returns json message' do
          expect(json['messages']).to include 'Question was successfully deleted.'
        end
      end
    end

    context 'not question author' do
      let(:other_user) { create(:user) }
      let(:other_question) { create(:question, user: other_user) }
      let(:other_api_path) { "/api/v1/questions/#{other_question.id}" }
      let(:params) { { access_token: access_token.token, id: "#{other_question.id}" } }

      before do
        do_request(:delete, other_api_path, params: params, headers: headers)
      end

      it 'returns status 403' do
        expect(response.status).to eq 403
      end

      it 'does not deletes question from the DB' do
        expect(Question.count).to eq 1
      end
    end
  end
end
