require 'rails_helper'

feature 'User can view a list of all questions', %q{
  In order see the answer to a specific question
  As a User
  I'd like to see a list of all questions
} do

  given(:user) { User.create(email: 'user@example.com', password: 'foobar') }
  given(:questions) { FactoryBot.create_list(:question_with_index, 5) }
  after do
    questions.each { |question| expect(page).to have_content question.title }
  end

  scenario 'Unauthenticated user tries to see a list of all questions' do
    visit questions_path(questions)
  end

  scenario 'Authenticated user tries to see a list of all questions' do
    login(user)
    visit questions_path(questions)
  end

end
