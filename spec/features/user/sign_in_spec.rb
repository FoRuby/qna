require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask question
  As User
  I'd like to be able to sign in
} do

  given(:registered_user) { FactoryBot.create(:user) }
  given(:registered_user_with_invalid_password) do
    FactoryBot.build(:user,
      email: registered_user.email,
      password: 'invalid_password'
    )
  end
  given(:unregistered_user) { FactoryBot.build(:user) }

  describe 'Registered user' do
    scenario 'tries to sign in with correct params' do
      login(registered_user)
      expect(page).to have_content 'Signed in successfully.'
    end

    scenario 'tries to sign in with incorrect params' do
      login(registered_user_with_invalid_password)
      expect(page).to have_content 'Invalid Email or password.'
    end
  end

  scenario 'Unregistered user tries to sign in' do
    login(unregistered_user)
    expect(page).to have_content 'Invalid Email or password.'
  end
end
