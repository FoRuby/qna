require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from community
  As an authenticated User
  I'd like to be able to ask the question
} do

  given(:user) { User.create(email: 'user@example.com', password: 'foobar') }
  given(:question) { create(:question) }

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

    scenario 'asks a question with attached files' do
      fill_in 'Title', with: question.title
      fill_in 'Body', with: question.body
      attach_file 'Files',
        [
          "#{Rails.root}/spec/rails_helper.rb",
          "#{Rails.root}/spec/spec_helper.rb"
        ]

      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path

    expect(page).to_not have_content 'Ask question'
  end
end
