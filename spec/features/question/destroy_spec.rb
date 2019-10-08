require 'rails_helper'

feature 'User can destroy question', %q{
  In order to delete question from system
  As User
  I'd like to be able to destroy question
} do

  given(:question_author) { create(:user) }
  given(:answer_author) { create(:user) }
  given(:question) do
    create(:question_with_answers,
      user: question_author,
      answers_author: answer_author
    )
  end

  describe 'Authenticated' do

    scenario 'author tries delete a question' do
      login(question_author)
      visit question_path(question)
      click_on 'Delete question'

      expect(page).to have_content 'Question successfully deleted.'
    end

    scenario 'user tries delete foreign question' do
      login(answer_author)
      visit question_path(question)

      expect(page).to_not have_content 'Delete question'
    end
  end

  scenario 'Unauthenticated user tries delete a question' do
    visit question_path(question)

    expect(page).to_not have_content 'Delete question'
  end
end
