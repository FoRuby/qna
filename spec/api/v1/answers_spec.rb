require 'rails_helper'

describe 'Answer API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:method) { :get }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 2, question: question) }

    it_behaves_like 'API Authorizable'
    context 'authorized' do
      let(:answer_response) { json['answers'].first }
      let(:access_token) { create(:access_token) }
      let(:params) { { access_token: access_token.token } }

      before { do_request(method, api_path, params: params, headers: headers) }

      it_behaves_like 'Successful request'

      it_behaves_like 'Public fields' do
        let(:attributes) { %w[id body best question_id created_at updated_at] }
        let(:resource_response) { answer_response }
        let(:resource) { answers.first }
      end

      it_behaves_like 'List' do
        let(:resource_response) { json['answers'] }
        let(:resource) { answers }
      end

      it 'contains user object' do
        expect(answer_response['user']['id']).to eq answers.first.user.id
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let!(:answer) { create(:answer) }
    let!(:comments) { create_list(:comment, 2, commentable: answer) }
    let!(:links) { create_list(:link, 2, linkable: answer) }
    let(:method) { :get }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer'] }
      let(:params) { { access_token: access_token.token } }

      before { do_request(method, api_path, params: params, headers: headers) }

      it_behaves_like 'Successful request'

      it_behaves_like 'Public fields' do
        let(:attributes) { %w[id body user_id question_id best created_at updated_at] }
        let(:resource_response) { answer_response }
        let(:resource) { answer }
      end

      describe 'comments' do
        it_behaves_like 'List' do
          let(:resource_response) { answer_response['comments'] }
          let(:resource) { comments }
        end
      end

      describe 'links' do
        it_behaves_like 'List' do
          let(:resource_response) { answer_response['links'] }
          let(:resource) { links }
        end
      end

      describe 'files' do
        it_behaves_like 'List' do
          let(:resource_response) { answer_response['files'] }
          let(:resource) { answer.files }
        end
      end
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    let(:question) { create(:question) }
    let(:method) { :post }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      context 'with valid attributes' do
        let(:params) do
          {
            question_id: question,
            answer: attributes_for(:answer),
            access_token: access_token.token
          }
        end

        it 'saves new answer in DB' do
          expect{
            do_request(method, api_path, params: params, headers: headers)
          }.to change(Answer, :count).by(1)
        end

        it 'returns status :created' do
          do_request(method, api_path, params: params, headers: headers)

          expect(response).to have_http_status(:created)
        end
      end

      context 'with invalid attributes' do
        let(:params) do
          {
            question_id: question,
            answer: attributes_for(:answer, :invalid_answer),
            access_token: access_token.token
          }
        end

        it 'does not save the answer' do
          expect{
            do_request(method, api_path, params: params, headers: headers)
          }.to_not change(Answer, :count)
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

  describe 'PATCH /api/v1/answers/:id' do
    let(:answer) { create(:answer) }
    let(:method) { :patch }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: answer.user.id) }

      context 'with valid attributes' do
        let(:params) do
          {
            answer: { body: 'New answer body' },
            access_token: access_token.token
          }
        end

        before { do_request(method, api_path, params: params, headers: headers) }

        it_behaves_like 'Successful request'

        it 'changes answer attributes' do
          expect{answer.reload}.to change(answer, :body).to('New answer body')
        end

        it 'returns status :created' do
          expect(response).to have_http_status(:created)
        end
      end

      context 'with invalid attributes' do
        let(:params) do
          {
            answer: attributes_for(:answer, :invalid_answer),
            access_token: access_token.token
          }
        end

        before { do_request(method, api_path, params: params, headers: headers) }

        it 'does not change answer attributes' do
          expect{answer.reload}.to not_change(answer, :body)
        end

        it 'returns status :unprocessable_entity' do
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns error message' do
          expect(json['errors']).to be
        end
      end
    end

    context 'not answer author tries to update answer' do
      let(:params) do
        {
          answer: { body: 'Edited body' },
          access_token: create(:access_token).token
        }
      end

      before { do_request(method, api_path, params: params, headers: headers) }

      it 'returns status :forbidden' do
        expect(response).to have_http_status(:forbidden)
      end

      it 'does not change answer attributes' do
        expect{answer.reload}.to_not change(answer, :body)
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let!(:answer) { create(:answer) }
    let(:method) { :delete }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: answer.user.id) }
      let(:params) { { access_token: access_token.token } }

      context 'delete answer' do
        it 'return 2xx status' do
          do_request(method, api_path, params: params, headers: headers)

          expect(response).to be_successful
        end

        it 'deletes answer from DB' do
          expect{
            do_request(method, api_path, params: params, headers: headers)
          }.to change{Answer.count}.by(-1)
        end

        it 'returns json message' do
          do_request(method, api_path, params: params, headers: headers)

          expect(json['messages']).to include 'Answer was successfully deleted.'
        end
      end
    end

    context 'not answer author tries to delete answer' do
      let(:params) { { access_token: create(:access_token).token } }

      it 'returns status :forbidden' do
        do_request(method, api_path, params: params, headers: headers)

        expect(response).to have_http_status(:forbidden)
      end

      it 'does not deletes answer from DB' do
        expect{
          do_request(method, api_path, params: params, headers: headers)
        }.to_not change{Answer.count}
      end
    end
  end
end
