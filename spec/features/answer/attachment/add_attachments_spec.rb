require 'rails_helper'

feature 'User can create answer for current question with attachments', %q{
  In order to help current question author
  As authenticated User
  I'd like to create answer for current question with attachments
} do

  given(:user) { create(:user) }
  given(:answer) { build(:answer, body: 'NewAnswerBody') }

  describe 'Authenticated user', js: true do
    background do
      login(user)
      visit question_path(answer.question)
    end

    scenario 'tries to create answer with attached files' do
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
  end

  describe 'Unauthenticated user', js: true do
    background do
      visit question_path(answer.question)
    end

    scenario 'tries to create answer with attached files' do
      expect(page).to_not have_content 'Create answer'
    end
  end
end
