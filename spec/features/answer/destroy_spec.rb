require 'rails_helper'

feature 'User can destroy answer', %q{
  In order to delete answer from system
  As author of answer
  I'd like to be able to destroy answer
} do

  given(:user) { create(:user) }
  given!(:answer) { create(:answer) }

  describe 'Authenticated', js: true do
    scenario 'answer author tries delete a answer' do
      login(answer.user)
      visit question_path(answer.question)

      expect(page).to have_content answer.body
      first(:link, 'Delete answer').click
      accept_confirm

      expect(page).to_not have_content answer.body
      expect(page).to have_content 'Answer successfully deleted.'
    end

    scenario 'user tries delete foreign answer' do
      login(user)
      visit question_path(answer.question)

      expect(page).to_not have_link 'Delete answer'
    end
  end

  scenario 'Unauthenticated user tries delete a answer' do
    visit question_path(answer.question)

    expect(page).to_not have_content 'Delete answer'
  end
end
