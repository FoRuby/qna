require 'rails_helper'

feature 'User can look a question with answers', %q{
  In order to search for an answer
  As User
  I'd like to see a question with all the answers
} do

  given(:user_author) { FactoryBot.create(:user_with_index) }
  given(:user) { FactoryBot.create(:user_with_index) }
  given(:question) do
    FactoryBot.create(:question_with_answers,
      author: user_author,
      answers_count: 3,
      answers_author: user
    )
  end

  after do
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    question.answers.each { |answer| expect(page).to have_content answer.body }
  end

  scenario 'Unauthenticated user tries to see a question with answers' do
    visit question_path(question)
  end

  scenario 'Authenticated user tries to see a question with answers' do
    login(user_author)
    visit question_path(question)
  end
end
