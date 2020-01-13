require 'rails_helper'

describe 'Answer API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions/:question_id/answers' do
    let(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 2, question: question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answers'].first }
      let(:params) { { access_token: access_token.token } }

      before do
        do_request(:get, api_path, params: params, headers: headers)
      end

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
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:answer_response) { json['answer'] }
      let(:params) { { access_token: access_token.token } }

      before do
        do_request(:get, api_path, params: params, headers: headers)
      end

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
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

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
        it 'saves new answer in DB' do
          expect {
            post api_path,
            params: {
              question_id: question,
              answer: attributes_for(:answer),
              access_token:access_token.token
            }
          }.to change(Answer, :count).by(1)
        end

        it 'returns status :created' do
          post api_path, params: {
            question_id: question,
            answer: attributes_for(:answer),
            access_token: access_token.token
          }

          expect(response.status).to eq 201
        end
      end

      context 'with invalid attributes' do
        it 'does not save the answer' do
          expect {
            post api_path,
            params: {
              question_id: question,
              answer: attributes_for(:answer, :invalid_answer),
              access_token: access_token.token
            }
          }.to_not change(Answer, :count)
        end

        it 'returns status :unprocessible_entity' do
          post api_path, params: {
            question_id: question,
            answer: attributes_for(:answer, :invalid_answer),
            access_token: access_token.token
          }

          expect(response.status).to eq 422
        end

        it 'returns error message' do
          post api_path, params: {
            question_id: question,
            answer: attributes_for(:answer, :invalid_answer),
            access_token: access_token.token
          }

          expect(json['errors']).to be
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:answer) { create(:answer, user: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      context 'with valid attributes' do
        before do
          patch api_path, params: {
            id: answer,
            answer: { body: 'New answer body' },
            access_token: access_token.token
          }
        end

        it_behaves_like 'Successful request'

        it 'changes answer attributes' do
          answer.reload

          expect(answer.body).to eq 'New answer body'
        end

        it 'returns status :created' do
          expect(response.status).to eq 201
        end
      end

      context 'with invalid attributes' do
        before do
          patch api_path, params: {
            id: answer,
            answer: { body: '' },
            access_token: access_token.token
          }
        end

        it 'does not change answer attributes' do
          expect { answer.reload }.to not_change(answer, :body)
            .and not_change(answer, :body)
        end

        it 'returns status :unprocessible_entity' do
          expect(response.status).to eq 422
        end

        it 'returns error message' do
          expect(json['errors']).to be
        end
      end
    end

    context 'not answer author tries to update answer' do
      let(:other_user) { create(:user) }
      let(:other_answer) { create(:answer, user: other_user) }
      let(:other_api_path) { "/api/v1/answers/#{other_answer.id}" }

      before do
        patch other_api_path, params: {
          id: other_answer,
          answer: { body: 'New answer body' },
          access_token: access_token.token }
      end

      it 'returns status 302' do
        expect(response.status).to eq 302
      end

      it 'does not change answer attributes' do
        other_answer.reload

        expect(other_answer.body).to_not eq 'New answer body'
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:answer) { create(:answer, user: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      context 'delete answer' do
        let(:params) { { access_token: access_token.token } }

        before do
          do_request(:delete, api_path, params: params, headers: headers)
        end

        it_behaves_like 'Successful request'

        it 'deletes answer from DB' do
          expect(Answer.count).to eq 0
        end

        it 'returns json message' do
          expect(json['messages']).to include 'Answer was successfully deleted.'
        end
      end
    end

    context 'not answer author' do
      let(:other_user) { create(:user) }
      let(:other_answer) { create(:answer, user: other_user) }
      let(:other_api_path) { "/api/v1/answers/#{other_answer.id}" }
      let(:params) { { access_token: access_token.token } }

      before do
        do_request(:delete, other_api_path, params: params, headers: headers)
      end

      it 'returns status 403' do
        expect(response.status).to eq 403
      end

      it 'does not deletes answer from DB' do
        expect(Answer.count).to eq 1
      end
    end
  end
end
