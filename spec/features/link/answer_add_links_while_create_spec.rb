require 'rails_helper'

feature 'User can add links to answer while create', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:links) { create_list(:link, 2) }
  given(:valid_link_url) { 'https://www.google.com/' }
  given(:invalid_link_url) { 'https//www.google.com/' }
  given(:valid_gist_url) { 'https://gist.github.com/FoRuby/f7059ba947b5d0138f302f8e43694348' }
  given(:invalid_gist_url) { 'https://gist.github.com/FoRuby/302f8e43694348' }

  describe 'Authenticated user', js: true do
    background do
      login(user)
      visit question_path(question)
      fill_in 'Body', with: 'AnswerBody'
    end

    context 'tries to create answer' do
      scenario 'with valid link' do
        fill_in 'Link name', with: 'Google'
        fill_in 'Url', with: valid_link_url

        click_on 'Create answer'

        within('.answers') do
          expect(page).to have_link('Google'), href: valid_link_url
        end
        expect(page).to have_field 'Link name', with: ''
        expect(page).to have_field 'Url', with: ''
      end

      scenario 'with valid links' do
        click_on 'Add link'

        fields = all('.nested-fields')
        fields.zip(links).each do |field, link|
          field.fill_in 'Link name', with: link.name
          field.fill_in 'Url', with: link.url
        end

        click_on 'Create answer'

        within('.answers') do
          links.each do |link|
            expect(page).to have_link link.name, href: link.url
          end
        end
        expect(page).to have_field 'Link name', with: ''
        expect(page).to have_field 'Url', with: ''
      end

      scenario 'with valid gist' do
        fill_in 'Link name', with: 'ValidGist'
        fill_in 'Url', with: valid_gist_url

        click_on 'Create answer'

        within('.answers') do
          expect(page).to have_content 'GistTitle'
        end
      end

      scenario 'with invalid link name' do
        fill_in 'Link name', with: ''
        fill_in 'Url', with: valid_link_url
        click_on 'Create answer'

        expect(page).to have_content "Links name can't be blank"
        expect(page).to have_field 'Link name', with: ''
        expect(page).to have_field 'Url', with: valid_link_url
      end

      scenario 'with invalid link url' do
        fill_in 'Link name', with: 'Google'
        fill_in 'Url', with: invalid_link_url
        click_on 'Create answer'

        expect(page).to have_content "Links url invalid format"
        expect(page).to have_field 'Link name', with: 'Google'
        expect(page).to have_field 'Url', with: invalid_link_url
      end

      scenario 'with invalid gist url' do
        fill_in 'Link name', with: 'InvalidGist'
        fill_in 'Url', with: invalid_gist_url
        click_on 'Create answer'

        expect(page).to_not have_content 'InvalidGist'
        expect(page).to_not have_link 'InvalidGist', href: invalid_gist_url
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    background do
      visit question_path(question)
    end

    scenario 'tries to create answer with links' do
      expect(page).to_not have_content 'Create answer'
    end
  end
end
