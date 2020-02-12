require 'rails_helper'

feature 'User can edit his answer with attached files', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer with attached files
} do

  given(:user) { create(:user) }
  given(:answer) { create(:answer) }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(answer.question)

    expect(page).to_not have_link 'Edit answer'
  end

  scenario "Authenticated user can not edit other user's answer" do
    login(user)
    visit question_path(answer.question)

    expect(page).to_not have_link 'Edit answer'
  end

  describe 'Authenticated answer author', js: true do
    background do
      login(answer.user)
      visit question_path(answer.question)
    end

    scenario 'tries to edit his answer with attached files' do
      click_on 'Edit answer'
      within "#answer-#{answer.id}" do
        attach_file 'Files', ["#{Rails.root}/spec/fixtures/files/image1.jpg",
                              "#{Rails.root}/spec/fixtures/files/image2.jpg"]

        click_on 'Save'

        expect(page).to have_link 'image1.jpg'
        expect(page).to have_link 'image2.jpg'
      end
    end
  end
end
