require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do

  given(:user) { create(:user) }
  given(:answer_author) { create(:user) }
  given(:question) do
    create(:question_with_answers,
      answers_author: answer_author
    )
  end
  given(:answer) { question.answers.first }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit answer'
  end

  describe 'Authenticated user', js: true do
    background do
      login(answer_author)
      visit question_path(question)
    end

    scenario 'tries to edit his answer with correct params' do
      click_on 'Edit answer'

      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    # scenario 'tries to edit his answer with incorrect params' do

    # end

    # scenario "tries to edit other user's answer" do

    # end
  end

end
