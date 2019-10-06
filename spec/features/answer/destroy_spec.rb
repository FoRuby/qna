require 'rails_helper'

feature 'User can destroy answer', %q{
  In order to delete answer from system
  As User
  I'd like to be able to destroy answer
} do

  given(:user_question_author) { FactoryBot.create(:user_with_index) }
  given(:user_answer_author) { FactoryBot.create(:user_with_index) }
  given(:question) do
    FactoryBot.create(:question_with_answers,
      author: user_question_author,
      answers_count: 2,
      answers_author: user_answer_author
    )
  end
  given(:answer) { question.answers.last }

  describe 'Authenticated' do

    scenario 'answer author tries delete a answer' do
      login(user_answer_author)
      visit question_path(question)
      first(:link, "Delete answer").click
      expect(page).to have_content 'Answer successfully deleted.'
    end

    scenario 'user tries delete foreign answer' do
      login(user_question_author)
      visit question_path(question)
      first(:link, "Delete answer").click
      expect(page).to have_content 'You can only delete your answer.'
    end
  end

  scenario 'Unauthenticated user tries delete a answer' do
    visit question_path(question)
    first(:link, "Delete answer").click
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
