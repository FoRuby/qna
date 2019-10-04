require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from community
  As an authenticated User
  I'd like to be able to ask the question
} do

  given(:user) { User.create(email: 'user@example.com', password: 'foobar') }
  given(:question) { FactoryBot.create(:question) }

  describe 'Authenticated user' do
    background do
      login(user)
      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      fill_in 'Title', with: question.title
      fill_in 'Body', with: question.body
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
