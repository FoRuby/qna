require 'rails_helper'

feature 'User can sign out', %q{
  In order to end the session
  As authorized user
  I'd like to sign out
} do

  given(:user) { create(:user) }

  scenario 'User tries to sign out' do
    login(user)
    # within('.header') { click_on 'Sign out' }
    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
