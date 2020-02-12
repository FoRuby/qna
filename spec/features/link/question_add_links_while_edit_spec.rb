require 'rails_helper'

feature 'User can add links to question while editing', %q{
  In order to provide additional info to my answer
  As an question author
  I'd like to be able to add links while edit question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:links) { create_list(:link, 2) }
  given(:valid_link_url) { 'https://www.google.com/' }
  given(:invalid_link_url) { 'https//www.google.com/' }
  given(:valid_gist_url) { 'https://gist.github.com/FoRuby/f7059ba947b5d0138f302f8e43694348' }
  given(:invalid_gist_url) { 'https://gist.github.com/FoRuby/302f8e43694348' }

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
            fill_in 'Url', with: valid_link_url
          end

          click_on 'Save'

          within('.question') { expect(page).to have_link 'Google', href: valid_link_url }
        end

        scenario 'with valid gist', :vcr do
          within '.edit-question-form' do
            fill_in 'Link name', with: 'ValidGist'
            fill_in 'Url', with: valid_gist_url
          end

          click_on 'Save'

          within('.question') { expect(page).to have_content 'GistTitle' }
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
            fill_in 'Url', with: valid_link_url
            click_on 'Save'
          end

          expect(page).to have_content "Links name can't be blank"
        end

        scenario 'with invalid link url' do
          within '.edit-question-form' do
            fill_in 'Link name', with: 'Google'
            fill_in 'Url', with: invalid_link_url
            click_on 'Save'
          end

          expect(page).to have_content 'Links url invalid format'
        end

        scenario 'with invalid gist', :vcr do
          within '.edit-question-form' do
            fill_in 'Link name', with: 'InvalidGist'
            fill_in 'Url', with: invalid_gist_url
          end

          click_on 'Save'

          within('.question') { expect(page).to_not have_content 'GistTitle' }
          within('.question') { expect(page).to_not have_link 'InvalidGist', href: invalid_gist_url }
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
