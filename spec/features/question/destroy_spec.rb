require 'rails_helper'

feature 'User can destroy question', %q{
  In order to delete question from system
  As User
  I'd like to be able to destroy question
} do

  given(:user_author) { FactoryBot.create(:user_with_index) }
  given(:user) { FactoryBot.create(:user_with_index) }
  given(:question) do
    FactoryBot.create(:question_with_answers,
      author: user_author,
      answers_count: 2,
      answers_author: user
    )
  end

  describe 'Authenticated' do

    scenario 'author tries delete a question' do
      login(user_author)
      visit question_path(question)
      click_on 'Delete question'
      expect(page).to have_content 'Question successfully deleted.'
    end

    scenario 'user tries delete foreign question' do
      login(user)
      visit question_path(question)
      click_on 'Delete question'
      expect(page).to have_content 'You can only delete your question.'
    end
  end

  scenario 'Unauthenticated user tries delete a question' do
    visit question_path(question)
    click_on 'Delete question'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
