require 'rails_helper'

feature 'User can unsubscribe from question', %q{
  In order to does not receive answer notifications
  As authenticated User
  I'd like to unsubscribe from question
} do

  given(:question) { create(:question) }
  given!(:subscription) { create(:subscription, question: question) }

  describe 'Authenticated', js: true do
    scenario 'subscriber tries to unsubscribe from question' do
      login(subscription.user)
      visit question_path(question)
      click_on 'Unsubscribe'

      expect(page).to have_content 'You successfully Unsubscribed'
      expect(page).to have_link 'Subscribe'
    end

    scenario 'question author tries to unsubscribe from his own question' do
      login(question.user)
      visit question_path(question)
      click_on 'Unsubscribe'

      expect(page).to have_content 'You successfully Unsubscribed'
      expect(page).to have_link 'Subscribe'
    end
  end

  scenario 'Unauthenticated user tries to unsubscribe from question' do
    visit question_path(question)

    expect(page).to_not have_link 'Unsubscribe'
  end
end
