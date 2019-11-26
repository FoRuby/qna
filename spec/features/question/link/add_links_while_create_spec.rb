require 'rails_helper'

feature 'User can add links to question while create', %q{
  In order to provide additional info to my question
  As question author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:links) { create_list(:link, 2) }
  given(:url) { 'https://www.google.com/' }
  given(:invalid_url) { 'https//www.google.com/' }

  describe 'Authenticated user', js: true do
    background do
      login(user)
      visit new_question_path
      fill_in 'Title', with: 'QuestionTitle'
      fill_in 'Body', with: 'QuestionBody'
    end

    context 'tries to create question' do
      scenario 'with valid link' do
        fill_in 'Link name', with: 'Google'
        fill_in 'Url', with: url

        click_on 'Ask'

        within('.question') do
          expect(page).to have_link('Google'), href: url
        end
      end

      scenario 'with valid links' do
        click_on 'Add link'

        fields = all('.nested-fields')
        fields.zip(links).each do |field, link|
          field.fill_in 'Link name', with: link.name
          field.fill_in 'Url', with: link.url
        end

        click_on 'Ask'

        within('.question') do
          links.each do |link|
            expect(page).to have_link link.name, href: link.url
          end
        end
      end

      scenario 'with invalid link name' do
        fill_in 'Link name', with: ''
        fill_in 'Url', with: url
        click_on 'Ask'

        expect(page).to have_content "Links name can't be blank"
        expect(page).to have_field 'Link name', with: ''
        expect(page).to have_field 'Url', with: url
      end

      scenario 'with invalid link url' do
        fill_in 'Link name', with: 'Google'
        fill_in 'Url', with: invalid_url
        click_on 'Ask'

        expect(page).to have_content "Links url invalid format"
        expect(page).to have_field 'Link name', with: 'Google'
        expect(page).to have_field 'Url', with: invalid_url
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    background do
      visit new_question_path
    end

    scenario 'tries to create question with links' do
      expect(page).to_not have_content 'Ask question'
    end
  end
end
