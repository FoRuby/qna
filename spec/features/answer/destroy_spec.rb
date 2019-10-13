require 'rails_helper'

feature 'User can destroy answer', %q{
  In order to delete answer from system
  As User
  I'd like to be able to destroy answer
} do

  given(:question_author) { create(:user) }
  given(:answer_author) { create(:user) }
  given(:question) do
    create(:question_with_answers,
      user: question_author,
      answers_count: 2,
      answers_author: answer_author
    )
  end
  given(:answer) { question.answers.first }

  describe 'Authenticated' do
    scenario 'answer author tries delete a answer' do
      login(answer_author)
      visit question_path(question)
      expect(page).to have_content answer.body
      first(:link, 'Delete answer').click

      expect(page).to_not have_content answer.body
      expect(page).to have_content 'Answer successfully deleted.'
    end

    scenario 'user tries delete foreign answer' do
      login(question_author)
      visit question_path(question)

      expect(page).to_not have_link 'Delete answer'
    end
  end

  scenario 'Unauthenticated user tries delete a answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Delete answer'
  end
end
