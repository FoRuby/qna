require 'rails_helper'

feature 'User can add links to answer while editing', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links while edit answer
} do

  given(:user) { create(:user) }
  given(:answer) { create(:answer) }
  given(:links) { create_list(:link, 2) }
  given(:valid_link_url) { 'https://www.google.com/' }
  given(:invalid_link_url) { 'https//www.google.com/' }
  given(:valid_gist_url) { 'https://gist.github.com/FoRuby/f7059ba947b5d0138f302f8e43694348' }
  given(:invalid_gist_url) { 'https://gist.github.com/FoRuby/302f8e43694348' }

  describe 'Authenticated', js: true do
    context 'Author' do
      background do
        login(answer.user)
        visit question_path(answer.question)
        click_on 'Edit answer'
      end

      context 'tries to edit answer' do
        scenario 'with valid link' do
          within '.edit-answer-form' do
            fill_in 'Link name', with: 'Google'
            fill_in 'Url', with: valid_link_url
          end

          click_on 'Save'

          within('.answers') { expect(page).to have_link 'Google', href: valid_link_url }
        end

        scenario 'with valid gist' do
          within '.edit-answer-form' do
            fill_in 'Link name', with: 'ValidGist'
            fill_in 'Url', with: valid_gist_url
          end

          click_on 'Save'

          within('.answers') { expect(page).to have_content 'GistTitle' }
        end

        scenario 'with valid links' do
          within '.answers' do
            click_on 'Add link'

            fields = all('.edit-answer-form .nested-fields')
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
          within '.edit-answer-form ' do
            fill_in 'Link name', with: ''
            fill_in 'Url', with: valid_link_url
            click_on 'Save'
          end

          expect(page).to have_content "Links name can't be blank"
        end

        scenario 'with invalid link url' do
          within '.edit-answer-form ' do
            fill_in 'Link name', with: 'Google'
            fill_in 'Url', with: invalid_link_url
            click_on 'Save'
          end

          expect(page).to have_content "Links url invalid format"
        end

        scenario 'with invalid gist url' do
          within '.edit-answer-form ' do
            fill_in 'Link name', with: 'InvalidGist'
            fill_in 'Url', with: invalid_gist_url
            click_on 'Save'
          end

          expect(page).to_not have_content 'GistTitle'
          expect(page).to_not have_link 'InvalidGist', href: invalid_gist_url
        end
      end
    end

    context 'Not author' do
      background do
        login(user)
        visit question_path(answer.question)
      end

      scenario 'tries to edit answer' do
        expect(page).to_not have_content 'Edit answer'
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    scenario 'tries to edit answer with link' do
      visit question_path(answer.question)
      expect(page).to_not have_content 'Edit answer'
    end
  end
end
