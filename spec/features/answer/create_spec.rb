require 'rails_helper'

feature 'User can create answer for current question', %q{
  In order to help current question author
  As User
  I'd like to create answer for current question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { build(:answer, body: 'NewAnswerBody') }

  describe 'Authenticated user', js: true do
    background do
      login(user)
      visit question_path(question)
    end

    scenario 'tries to create answer for current question with correct params' do
      fill_in 'Your answer', with: answer.body
      click_on 'Create answer'
      expect(page).to have_content answer.body
      expect(page).to have_content "Answer successfully created."
    end

    scenario 'tries to create answer for current question with attached files' do
      fill_in 'Your answer', with: answer.body
      attach_file 'Files',
      [
        "#{Rails.root}/spec/fixtures/files/image1.jpg",
        "#{Rails.root}/spec/fixtures/files/image2.jpg"
      ]

      click_on 'Create answer'

      expect(page).to have_link 'image1.jpg'
      expect(page).to have_link 'image2.jpg'
    end

    scenario 'tries to create answer for current question with incorrect params' do
      click_on 'Create answer'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to create answer for current question' do
    visit question_path(question)

    expect(page).to_not have_content 'Create answer'
  end
end
