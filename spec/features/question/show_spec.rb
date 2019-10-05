require 'rails_helper'

feature 'User can create question', %q{
  In order to search for an answer
  As User
  I'd like to see a question with all the answers
} do

  given(:user) { User.create(email: 'user@example.com', password: 'foobar') }
  given(:question) { FactoryBot.create(:question_with_index) }
  after do
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    question.answers.each { |answer| expect(page).to have_content answer.body }
  end

  scenario 'Unauthenticated user tries to see a question with answers' do
    visit question_path(question)
  end

  scenario 'Authenticated user tries to see a question with answers' do
    login(user)
    visit question_path(question)
  end
end
