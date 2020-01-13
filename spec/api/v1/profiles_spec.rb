require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { 'CONTENT_TYPE' => 'application/json',
                    'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:me) { create(:admin) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      let(:user_response) { json['user'] }

      before do
        do_request(:get, api_path, params: { access_token: access_token.token }, headers: headers)
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
    let(:api_path) { '/api/v1/profiles' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:users) { create_list(:user, 2) }

      let(:user) { users.first }
      let(:users_response) { json['users'].first }

      before do
        do_request(:get, api_path, params: { access_token: access_token.token }, headers: headers)
      end

      it_behaves_like 'Successful request'

      it_behaves_like 'Public fields' do
        let(:attributes) { %w[id email admin created_at updated_at] }
        let(:resource_response) { users_response }
        let(:resource) { user }
      end

      it_behaves_like 'Private fields' do
        let(:attributes) { %w[password encrypted_password] }
        let(:resource_response) { users_response }
      end

      it_behaves_like 'List' do
        let(:resource_response) { json['users'] }
        let(:resource) { users }
      end
    end
  end
end
