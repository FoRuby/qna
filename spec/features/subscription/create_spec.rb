require 'rails_helper'

feature 'User can subscribe on question', %q{
  In order to receive answer notifications
  As authenticated User
  I'd like to subscribe on question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated', js: true do
    scenario 'user tries to subscribe on question' do
      login(user)
      visit question_path(question)
      click_on 'Subscribe'

      expect(page).to have_content 'You successfully Subscribed'
      expect(page).to have_link 'Unsubscribe'
    end

    scenario 'question author tries to subscribe on his own question' do
      login(question.user)
      visit question_path(question)

      expect(page).to_not have_link 'Subscribe'
    end
  end

  describe 'Unauthenticated' do
    scenario 'user tries to subscribe on question' do
      visit question_path(question)

      expect(page).to_not have_link 'Subscribe'
    end
  end
end
