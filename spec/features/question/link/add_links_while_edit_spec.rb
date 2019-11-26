require 'rails_helper'

feature 'User can add links to question while editing', %q{
  In order to provide additional info to my answer
  As an question author
  I'd like to be able to add links while edit question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:links) { create_list(:link, 2) }
  given(:url) { 'https://www.google.com/' }
  given(:invalid_url) { 'https//www.google.com/' }

  describe 'Authenticated', js: true do
    context 'Author' do
      background do
        login(question.user)
        visit question_path(question)
        click_on 'Edit question'
      end

      context 'tries to edit question' do
        scenario 'with valid link' do
          within '.edit-question-form' do
            fill_in 'Link name', with: 'Google'
            fill_in 'Url', with: url
          end

          click_on 'Save'

          within('.question') { expect(page).to have_link 'Google', href: url }
        end

        scenario 'with valid links' do
          within '.question' do
            click_on 'Add link'

            fields = all('.edit-question-form .nested-fields')
            fields.zip(links).each do |field, link|
              field.fill_in 'Link name', with: link.name
              field.fill_in 'Url', with: link.url
            end
            click_on 'Save'

            links.each do |link|
              expect(page).to have_link link.name, href: link.url
            end
          end
        end

        scenario 'with invalid link name' do
          within '.edit-question-form' do
            fill_in 'Link name', with: ''
            fill_in 'Url', with: url
            click_on 'Save'
          end

          expect(page).to have_content "Links name can't be blank"
        end

        scenario 'with invalid link url' do
          within '.edit-question-form' do
            fill_in 'Link name', with: 'Google'
            fill_in 'Url', with: invalid_url
            click_on 'Save'
          end

          expect(page).to have_content "Links url invalid format"
        end
      end
    end

    context 'Not author' do
      background do
        login(user)
        visit question_path(question)
      end

      scenario 'tries to edit question' do
        expect(page).to_not have_content 'Edit question'
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    scenario 'tries to edit question with link' do
      visit question_path(question)
      expect(page).to_not have_content 'Edit question'
    end
  end
end
