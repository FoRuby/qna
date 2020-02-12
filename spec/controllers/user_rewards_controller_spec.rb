require 'rails_helper'

RSpec.describe UserRewardsController, type: :controller do

  let(:user) { create(:user) }

  describe 'GET #index' do
    context 'Authorized user' do
      let(:rewards) { create_list(:reward, 2, user: user) }

      before do
        login(user)
        get :index
      end

      it 'assign @rewards to array of all user rewards' do
        expect(assigns(:user_rewards)).to match_array(rewards)
      end

      it 'render index view' do
        expect(response).to render_template :index
      end

      it 'returns status :ok' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'Unauthorized user' do
      before { get :index }

      it 'does not assign @rewards to array of all user rewards' do
        expect(assigns(:user_rewards)).to be_nil
      end

      it 'does not render index view' do
        expect(response).to_not render_template :index
      end

      it 'redirect to login page' do
        expect(response).to redirect_to(new_user_session_path)
      end

      it 'returns status :redirect' do
        expect(response).to have_http_status(:redirect)
      end
    end
  end
end
