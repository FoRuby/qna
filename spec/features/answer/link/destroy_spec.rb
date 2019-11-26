require 'rails_helper'

feature 'User can destroy answer link', %q{
  In order to delete answer link from system
  As User
  I'd like to be able to destroy answer link
} do

  given(:user) { create(:user) }
  given(:answer) { create(:answer) }
  given!(:link) { create(:link, linkable: answer) }

  describe 'Authenticated', js: true do
    context 'Author' do
      scenario 'tries delete a answer link' do
        login(answer.user)
        visit question_path(answer.question)

        within '.answers' do
          click_on 'Edit answer'
          find('.delete-icon').click
          accept_confirm

          within '.edit-answer-form' do
            expect(page).to_not have_link link.name, href: link.url
            expect(page).to_not have_selector('.delete-icon')
          end

          click_on 'Save'

          within '.answer-content' do
            expect(page).to_not have_link link.name, href: link.url
          end
        end
      end
    end

    context 'Not Author' do
      scenario 'tries delete a answer link' do
        login(user)
        visit question_path(answer.question)

        within '.answers' do
          expect(page).to_not have_content 'Edit answer'
          expect(page).to_not have_selector('.delete-icon')
        end
      end
    end
  end

  describe 'Unauthenticated', js: true do
    scenario 'user tries delete answer link' do
      visit question_path(answer.question)

      within '.answers' do
        expect(page).to_not have_content 'Edit answer'
        expect(page).to_not have_selector('.delete-icon')
      end
    end
  end
end

