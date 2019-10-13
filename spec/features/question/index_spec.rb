require 'rails_helper'

feature 'User can view a list of all questions', %q{
  In order see the answer to a specific question
  As a User
  I'd like to see a list of all questions
} do

  given(:user) { create(:user) }
  given(:questions) { create_list(:question, 3, user: user) }

  scenario 'Unauthenticated user tries to see a list of all questions' do
    visit questions_path(questions)

    questions.each { |question| expect(page).to have_content question.title }
  end

  scenario 'Authenticated user tries to see a list of all questions' do
    login(user)
    visit questions_path(questions)

    questions.each { |question| expect(page).to have_content question.title }
  end

end
