require 'rails_helper'

feature 'User can destroy question link', %q{
  In order to delete question link from system
  As User
  I'd like to be able to destroy question link
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:link) { create(:link, linkable: question) }

  describe 'Authenticated', js: true do
    context 'Author' do
      scenario 'tries delete question link' do
        login(question.user)
        visit question_path(question)

        within '.question' do
          within '.question-content' do
            expect(page).to have_link link.name, href: link.url
          end

          click_on 'Edit question'
          find('.delete-icon').click
          accept_confirm

          within '.edit-question-form' do
            expect(page).to_not have_link link.name, href: link.url
            expect(page).to_not have_selector('.delete-icon')
          end

          click_on 'Save'

          within '.question-content' do
            expect(page).to_not have_link link.name, href: link.url
          end
        end
      end
    end

    context 'Not Author' do
      scenario 'tries delete question link' do
        login(user)
        visit question_path(question)

        within '.question' do
          expect(page).to_not have_content 'Edit question'
          expect(page).to_not have_selector('.delete-icon')
        end
      end
    end
  end

  describe 'Unauthenticated', js: true do
    scenario 'user tries delete question link' do
      visit question_path(question)

      within '.question' do
        expect(page).to_not have_content 'Edit question'
        expect(page).to_not have_selector('.delete-icon')
      end
    end
  end
end
