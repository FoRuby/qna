require 'rails_helper'

feature 'User can view rewards list', %q{
  In order to look my achievements
  As User
  I want to be able to view all rewards
} do

  describe 'Authenticated user' do
    given(:user) { create(:user) }
    context 'With rewards' do
      given!(:user_rewards) { create_list(:reward, 2, user: user) }
      given!(:another_user_reward) { create(:reward) }

      background do
        login(user)
        visit user_rewards_path
      end

      scenario 'sees a list of his rewards' do
        user_rewards.each do |reward|
          expect(page).to have_content reward.title
          expect(page).to have_content reward.question.title
        end
      end

      scenario "doesn't see other users's rewards" do
        expect(page).to_not have_content another_user_reward.title
        expect(page).to_not have_content another_user_reward.question.title
      end
    end

    context 'Without rewards' do
      background do
        login(user)
        visit user_rewards_path
      end

      scenario "sees 'No rewards message'" do
        expect(page).to have_content 'No Rewards yet.'
      end
    end
  end

  describe 'Unauthenticated user' do
    given(:user) { create(:user) }
    given!(:user_rewards) { create_list(:reward, 2, user: user) }

    background do
      visit root_path
    end

    scenario 'does not see rewards link' do
      expect(page).to_not have_link 'Rewards', href: user_rewards_path
    end
  end
end
