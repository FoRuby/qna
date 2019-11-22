require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:url) { 'https://www.google.com/' }

  #спеки с валидацией ссылок

  scenario 'User adds link when asks question', js: true do
    login(user)
    visit new_question_path

    fill_in 'Title', with: 'QuestionTitle'
    fill_in 'Body', with: 'QuestionBody'

    fill_in 'Link name', with: 'Google'
    fill_in 'Url', with: url

    click_on 'Ask'

    expect(page).to have_link('Google'), href: url
  end
end