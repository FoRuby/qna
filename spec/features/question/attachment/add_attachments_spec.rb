require 'rails_helper'

feature 'User can create question with attachments', %q{
  In order to help current question author
  As authenticated User
  I'd like to create question with attachments
} do

  given(:user) { create(:user) }

  describe 'Authenticated user', js: true do
    background do
      login(user)
      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question with attached files' do
      fill_in 'Title', with: 'Title'
      fill_in 'Body', with: 'Body'
      attach_file 'Files',
        [
          "#{Rails.root}/spec/fixtures/files/image1.jpg",
          "#{Rails.root}/spec/fixtures/files/image2.jpg"
        ]

      click_on 'Ask'

      expect(page).to have_link 'image1.jpg'
      expect(page).to have_link 'image2.jpg'
    end
  end

  describe 'Unauthenticated user', js: true do
    background do
      visit questions_path
    end

    scenario 'tries to create question with attached files' do
      expect(page).to_not have_content 'Ask question'
    end
  end
end
