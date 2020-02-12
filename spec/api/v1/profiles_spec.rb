require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json',
                    'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/profiles/me' do
    let(:method) { :get }
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:me) { create(:admin) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      let(:user_response) { json['user'] }

      before do
        do_request(
          method,
          api_path, params: { access_token: access_token.token },
          headers: headers
        )
      end

      it_behaves_like 'Successful request'

      it_behaves_like 'Public fields' do
        let(:attributes) { %w[id email admin created_at updated_at] }
        let(:resource_response) { user_response }
        let(:resource) { me }
      end

      it_behaves_like 'Private fields' do
        let(:attributes) { %w[password encrypted_password] }
        let(:resource_response) { user_response }
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    let(:method) { :get }
    let(:api_path) { '/api/v1/profiles' }

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:users) { create_list(:user, 2) }
      let(:users_response) { json['users'] }
      let(:public_fields) { %w[id email admin created_at updated_at] }
      let(:private_fields) { %w[password encrypted_password] }

      before do
        do_request(
          method,
          api_path, params: { access_token: access_token.token },
          headers: headers
        )
      end

      it_behaves_like 'Successful request'


      it 'return public fields for each user' do
        users.zip(users_response).each do |user, user_response|
          public_fields.each do |attr|
            expect(user_response[attr]).to eq user.send(attr).as_json
          end
        end
      end

      it 'does not return private fields for each user' do
        users_response.each do |user_response|
          private_fields.each do |attr|
            expect(user_response).to_not have_key(attr)
          end
        end
      end

      it_behaves_like 'List' do
        let(:resource_response) { users_response }
        let(:resource) { users }
      end

      it 'response does not include access_token user' do
        expect(json['users'].map { |e| e['id'] })
          .to_not include access_token.resource_owner_id
      end
    end
  end
end
