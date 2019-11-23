require 'rails_helper'

feature 'User can destroy question attachment', %q{
  In order to delete question attachment from system
  As question author
  I'd like to be able to destroy question attachment
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:question_attached_file) { question.files.attach(create_file_blob).first }

  describe 'Authenticated', js: true do
    scenario 'question author tries delete a question attachment' do
      login(question.user)
      visit question_path(question)

      within '.question' do
        click_on 'Delete attachments'
        find('.delete-attachment-icon').click
        accept_confirm

        expect(page).to_not have_content question_attached_file.filename.to_s
        expect(page).to_not have_selector('.delete-attachment-icon')
      end
      expect(page).to have_content 'Attachment successfully deleted.'
    end

    scenario 'user tries delete foreign question attachment' do
      login(user)
      visit question_path(question)
      within '.question' do
        expect(page).to_not have_content 'Delete attachments'
        expect(page).to_not have_selector('.delete-attachment-icon')
      end
    end
  end

  describe 'Unauthenticated', js: true do
    scenario 'user tries delete a question attachment' do
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_content 'Delete attachments'
        expect(page).to_not have_selector('.delete-attachment-icon')
      end
    end
  end
end

