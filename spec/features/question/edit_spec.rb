require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As author of question
  I'd like to be able to edit my question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Unauthenticated user can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  scenario "Authenticated user can not edit other user's question" do
    login(user)
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  describe 'Authenticated question author', js: true do
    background do
      login(question.user)
      visit question_path(question)
    end

    scenario 'tries to edit his question with correct params' do
      click_on 'Edit question'

      within '.question' do
        fill_in 'Title', with: 'New Question Title'
        fill_in 'Body', with: 'New Question Body'
        click_on 'Save'

        expect(page).to have_content 'New Question Title'
        expect(page).to have_content 'New Question Body'
        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to_not have_selector '#question_title'
        expect(page).to_not have_selector '#question_body'
      end
      expect(page).to have_content 'Question successfully edited.'
    end

    scenario 'tries to edit his question with incorrect params' do
      click_on 'Edit question'

      within '.question' do
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
        expect(page).to have_selector '#question_title'
        expect(page).to have_selector '#question_body'
      end
    end

    scenario 'tries to cancel question editing' do
      click_on 'Edit question'
      click_on 'Cancel'

      within '.question' do
        expect(page).to have_content question.title
        expect(page).to have_content question.body
        expect(page).to have_link 'Edit question'
      end
    end
  end
end
