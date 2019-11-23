require 'rails_helper'

feature 'User can look a question with answers', %q{
  In order to search for an answer
  As User
  I'd like to see a question with all the answers
} do

  given(:user) { create(:user) }
  given(:question) { create(:question_with_answers, answers_count: 3) }

  scenario 'Unauthenticated user tries to see a question with answers' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    question.answers.each { |answer| expect(page).to have_content answer.body }
  end

  scenario 'Authenticated user tries to see a question with answers' do
    login(question.user)
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    question.answers.each { |answer| expect(page).to have_content answer.body }
  end
end
