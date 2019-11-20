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

  scenario "Authenticated user can not edit other user's answer" do
    login(user)
    visit question_path(question)

    expect(page).to_not have_link 'Edit answer'
  end

  describe 'Authenticated answer author', js: true do
    background do
      login(answer_author)
      visit question_path(question)
    end

    scenario 'tries to edit his answer with correct params' do
      click_on 'Edit answer'

      within '.answers' do
        old_answer_body = answer.body
        fill_in 'Edit your answer:', with: 'Edited answer'
        click_on 'Save'

        expect(page).to_not have_content old_answer_body
        expect(page).to have_content 'Edited answer'
        expect(page).to_not have_selector '#answer_body'
      end
      expect(page).to have_content 'Answer successfully edited.'
    end

    scenario 'tries to edit his answer with attached files' do
      click_on 'Edit answer'
      within "#answer-#{answer.id}" do
        attach_file 'Files',
          [
            "#{Rails.root}/spec/fixtures/files/image1.jpg",
            "#{Rails.root}/spec/fixtures/files/image2.jpg"
          ]

        click_on 'Save'

        expect(page).to have_link 'image1.jpg'
        expect(page).to have_link 'image2.jpg'
      end
    end

    scenario 'tries to edit his answer with incorrect params' do
      click_on 'Edit answer'

      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body
        expect(page).to have_content "Body can't be blank"
        expect(page).to have_selector '#answer_body'
      end
    end

    scenario 'tries to cancel question editing' do
      click_on 'Edit answer'
      click_on 'Cancel'

      within '.answers' do
        expect(page).to have_content answer.body
        expect(page).to have_link 'Edit answer'
      end
    end
  end
end
