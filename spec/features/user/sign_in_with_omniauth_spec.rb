require 'rails_helper'

feature 'Authorization from providers', %q{
  In order to have access to app
  As a user
  I want to be able to sign in with my social network accounts
} do

  given!(:user) { create(:user) }

  background { visit new_user_registration_path }

  describe 'Sign in with Github' do
    scenario 'existing user' do
      mock_auth :github, email: user.email
      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Successfully authenticated from Github account.'
    end

    scenario "oauth provider doesn't have user's email" do
      mock_auth :github
      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Confirm your email'
      fill_in 'email', with: 'new_user@example.com'
      click_on 'Confirm'

      open_email('new_user@example.com')
      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'
    end
  end

  describe 'Sign in with Yandex' do
    scenario 'existing user' do
      mock_auth :yandex, email: user.email
      click_on 'Sign in with Yandex'

      expect(page).to have_content 'Successfully authenticated from Yandex account.'
    end

    scenario "oauth provider doesn't have user's email" do
      mock_auth :yandex
      click_on 'Sign in with Yandex'

      expect(page).to have_content 'Confirm your email'
      fill_in 'email', with: 'new_user@example.com'
      click_on 'Confirm'

      open_email('new_user@example.com')
      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'
    end
  end

  describe 'Sign in with Vkontakte' do
    before do
      mock_auth :vkontakte
      click_on 'Sign in with Vkontakte'
    end

    scenario 'Try to sign up with invalid email', js: true do
      fill_in 'Email', with: 'invalid_email'
      click_on 'Confirm'

      expect(current_path).to eql(user_vkontakte_omniauth_authorize_path)
      expect(page).to_not have_content 'We send you email on invalid_email for confirmation'
    end

    scenario 'existing user' do
      fill_in 'Email', with: user.email
      click_on 'Confirm'

      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
    end

    scenario 'does not existing user' do
      fill_in 'Email', with: 'new_user@example.com'
      click_on 'Confirm'

      expect(page).to have_content 'We send you email on new_user@example.com for confirmation'

      open_email 'new_user@example.com'
      current_email.click_link 'Confirm my account'

      expect(page).to have_content 'Your email address has been successfully confirmed'

      visit new_user_registration_path
      click_on 'Sign in with Vkontakte'

      expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
    end
  end
end
