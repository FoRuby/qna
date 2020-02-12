require 'rails_helper'

feature 'User can destroy answer attachment', %q{
  In order to delete answer attachment from system
  As User
  I'd like to be able to destroy answer attachment
} do

  given(:user) { create(:user) }
  given(:answer) { create(:answer) }
  given!(:answer_attached_file) { answer.files.attach(create_file_blob).first }

  describe 'Authenticated', js: true do
    scenario 'answer author tries delete a answer attachment' do
      login(answer.user)
      visit question_path(answer.question)

      within "#answer-#{answer.id}" do
        expect(page).to have_content answer_attached_file.filename.to_s

        click_on 'Edit answer'
        find('.delete-icon').click
        accept_confirm

        expect(page).to_not have_content answer_attached_file.filename.to_s
        expect(page).to_not have_selector('.delete-icon')
      end
      expect(page).to have_content 'Attachment successfully deleted.'
    end

    scenario 'user tries delete foreign answer attachment' do
      login(user)
      visit question_path(answer.question)

      within "#answer-#{answer.id}" do
        expect(page).to_not have_selector('.delete-icon')
      end
    end
  end

  describe 'Unauthenticated', js: true do
    scenario 'user tries delete a answer attachment' do
      visit question_path(answer.question)

      within "#answer-#{answer.id}" do
        expect(page).to_not have_selector('.delete-icon')
      end
    end
  end
end
