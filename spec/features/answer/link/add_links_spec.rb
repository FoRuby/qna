require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:url) { 'https://www.google.com/' }

  #спеки с валидацией ссылок

  scenario 'User adds link when asks question', js: true do
    login(user)
    visit question_path(question)

    fill_in 'Your answer', with: 'AnswerBody'
    fill_in 'Link name', with: 'Google'
    fill_in 'Url', with: url

    click_on 'Create answer'

    within('.answers') do
      expect(page).to have_link('Google'), href: url
    end
  end
end
