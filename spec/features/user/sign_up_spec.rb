require 'rails_helper'

feature 'User can sign up', %q{
  In order to ask question
  As User
  I'd like to be able to sign up
} do

  given(:user_with_valid_params) { FactoryBot.build(:user) }
  given(:registered_user) do
    FactoryBot.create(:user,
      email: 'registered_email@example.com',
      password: 'foobar',
      password_confirmation: 'foobar'
    )
  end
  given(:user_with_invalid_password_length) do
    FactoryBot.build(:user, password: '5char', password_confirmation: '5char')
  end
  given(:user_with_different_passwords) do
    FactoryBot.build(:user, password: 'foobar', password_confirmation: 'fobar')
  end

  describe 'User tries to sign up' do
    scenario 'with valid params' do
      sign_up(user_with_valid_params)
      expect(page).to have_content 'Welcome! You have signed up successfully.'
    end

    scenario 'with invalid password length' do
      sign_up(user_with_invalid_password_length)
      expect(page).to have_content 'Password is too short (minimum is 6 characters)'
    end

    scenario 'with different values in the fields Password and Password confirmation' do
      sign_up(user_with_different_passwords)
      expect(page).to have_content "Password confirmation doesn't match Password"
    end

    scenario 'with existing Email' do
      sign_up(registered_user)
      expect(page).to have_content 'Email has already been taken'
    end

    scenario 'repeatedly' do
      sign_up(user_with_valid_params)
      visit new_user_registration_path
      expect(page).to have_content 'You are already signed in.'
    end
  end
end
