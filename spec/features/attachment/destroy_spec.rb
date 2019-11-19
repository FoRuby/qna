require 'rails_helper'

feature 'User can destroy question attachment', %q{
  In order to delete question attachment from system
  As User
  I'd like to be able to destroy question attachment
} do

  given(:question_author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: question_author) }
  given!(:attached_file) { question.files.attach(create_file_blob).first }

  describe 'Authenticated', js: true do
    scenario 'question author tries delete a question attachment' do
      login(question_author)
      visit question_path(question)
      click_on 'Delete attachment'

      find("#delete-attachment-icon-#{attached_file.id}").click
      accept_confirm

      expect(page).to have_content 'Attachment successfully deleted.'
      expect(page).to_not have_content attached_file.filename.to_s
      expect(page).to_not have_selector('.delete-attachment-icon')
    end


    # scenario 'author tries delete a answer attachment' do

    # end

    scenario 'user tries delete foreign question attachment' do
      login(user)
      visit question_path(question)

      expect(page).to_not have_link 'Delete attachment'
      expect(page).to_not have_selector('.delete-attachment-icon')
    end

    # scenario 'user tries delete foreign answer attachment' do

    # end
  end

  describe 'Unauthenticated', js: true do
    scenario 'user tries delete a question attachment' do
      visit question_path(question)

      expect(page).to_not have_content 'Delete question'
      expect(page).to_not have_selector('.delete-attachment-icon')
    end

    # scenario 'user tries delete a answer attachment' do

    # end
  end
end

