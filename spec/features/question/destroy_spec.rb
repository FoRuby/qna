require 'rails_helper'

feature 'User can destroy question', %q{
  In order to delete question from system
  As author of question
  I'd like to be able to destroy question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated' do
    scenario 'question author tries delete a question' do
      login(question.user)
      visit question_path(question)
      click_on 'Delete question'

      expect(page).to_not have_content question
      expect(page).to have_content 'Question successfully deleted.'
    end

    scenario 'user tries delete foreign question' do
      login(user)
      visit question_path(question)

      expect(page).to_not have_link 'Delete question'
    end
  end

  scenario 'Unauthenticated user tries delete a question' do
    visit question_path(question)

    expect(page).to_not have_content 'Delete question'
  end
end
