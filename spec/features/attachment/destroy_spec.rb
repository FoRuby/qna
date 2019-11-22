require 'rails_helper'

feature 'User can destroy question attachment', %q{
  In order to delete question attachment from system
  As User
  I'd like to be able to destroy question attachment
} do

  given(:user) { create(:user) }

  given(:question_author) { create(:user) }
  given(:question) { create(:question, user: question_author) }
  given!(:question_attached_file) { question.files.attach(create_file_blob).first }

  given(:answer_author) { create(:user) }
  given(:answer) { create(:answer, question: question, user: answer_author) }
  given!(:answer_attached_file) { answer.files.attach(create_file_blob).first }

  describe 'Authenticated', js: true do
    scenario 'question author tries delete a question attachment' do
      login(question_author)
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


    scenario 'answer author tries delete a answer attachment' do
      login(answer_author)
      visit question_path(question)

      within "#answer-#{answer.id}" do
        click_on 'Delete attachments'
        find('.delete-attachment-icon').click
        accept_confirm

        expect(page).to_not have_content answer_attached_file.filename.to_s
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

    scenario 'user tries delete foreign answer attachment' do
      login(user)
      visit question_path(question)
      within "#answer-#{answer.id}" do
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

    scenario 'user tries delete a answer attachment' do
      visit question_path(question)

      within "#answer-#{answer.id}" do
        expect(page).to_not have_content 'Delete attachments'
        expect(page).to_not have_selector('.delete-attachment-icon')
      end
    end
  end
end

