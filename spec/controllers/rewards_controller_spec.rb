require 'rails_helper'

RSpec.describe RewardsController, type: :controller do

  let(:user) { create(:user) }

  describe 'GET #index' do
    context 'Authorized user' do
      let(:rewards) { create_list(:reward, 3, user: user) }

      before do
        login(user)
        get :index
      end

      it 'assign @rewards to array of all user rewards' do
        expect(assigns(:rewards)).to match_array(rewards)
      end

      it 'render index view' do
        expect(response).to render_template :index
      end
    end

    context 'Unauthorized user' do
      before { get :index }

      it 'does not assign @rewards to array of all user rewards' do
        expect(assigns(:rewards)).to be_nil
      end

      it 'does not render index view' do
        expect(response).to_not render_template :index
      end

      it 'returns 302 status code redirect to login page' do
        expect(response).to have_http_status(302)
      end
    end
  end
end
