require 'rails_helper'

feature 'User can edit his question with attached files', %q{
  In order to correct mistakes
  As question author
  I'd like to be able to edit my question with attached files
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

    scenario 'tries to edit his question with attached files' do
      click_on 'Edit question'
      within '.question' do
        attach_file 'Files',
          [
            "#{Rails.root}/spec/fixtures/files/image1.jpg",
            "#{Rails.root}/spec/fixtures/files/image2.jpg"
          ]
      end

      click_on 'Save'

      expect(page).to have_link 'image1.jpg'
      expect(page).to have_link 'image2.jpg'
    end
  end
end
