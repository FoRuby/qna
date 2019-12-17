require 'rails_helper'

feature 'When user creates a new answer,
  then this answer appears for all users,
  who are on the same question page' do

  given(:user) { create(:user) }
  given(:question1) { create(:question) }
  given(:question2) { create(:question) }

  context 'mulitple sessions', js: true do
    scenario 'answer appears for all users
      who are on the same question page' do
      Capybara.using_session('user') do
        login(user)
        visit question_path(question1)

        expect(page).to_not have_link 'image1.jpg'
        expect(page).to_not have_link 'Google', href: 'https://www.google.com/'
        expect(page).to_not have_content 'AnswerBody'
      end

      Capybara.using_session('guest') do
        visit question_path(question1)

        expect(page).to_not have_link 'image1.jpg'
        expect(page).to_not have_link 'Google', href: 'https://www.google.com/'
        expect(page).to_not have_content 'AnswerBody'
      end

      Capybara.using_session('user') do
        fill_in 'Body', with: 'AnswerBody'
        fill_in 'Link name', with: 'Google'
        fill_in 'Url', with: 'https://www.google.com/'
        attach_file 'Files',"#{Rails.root}/spec/fixtures/files/image1.jpg"

        click_on 'Create answer'

        within('.answers') do
          expect(page).to have_link 'image1.jpg'
          expect(page).to have_link 'Google', href: 'https://www.google.com/'
          expect(page).to have_content 'AnswerBody'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to have_link 'image1.jpg'
        expect(page).to have_link 'Google', href: 'https://www.google.com/'
        expect(page).to have_content 'AnswerBody'
        expect(page).to have_content 'There was a new Answer.'
      end
    end

    scenario 'answer does not appears for user
      who are not on the same question page' do
      Capybara.using_session('user') do
        login(user)
        visit question_path(question1)
      end

      Capybara.using_session('guest') do
        visit question_path(question2)
      end

      Capybara.using_session('user') do
        fill_in 'Body', with: 'AnswerBody'
        fill_in 'Link name', with: 'Google'
        fill_in 'Url', with: 'https://www.google.com/'
        attach_file 'Files',"#{Rails.root}/spec/fixtures/files/image1.jpg"

        click_on 'Create answer'

        within('.answers') do
          expect(page).to have_link 'image1.jpg'
          expect(page).to have_link 'Google', href: 'https://www.google.com/'
          expect(page).to have_content 'AnswerBody'
        end
      end

      Capybara.using_session('guest') do
        expect(page).to_not have_link 'image1.jpg'
        expect(page).to_not have_link 'Google', href: 'https://www.google.com/'
        expect(page).to_not have_content 'AnswerBody'
        expect(page).to_not have_content 'There was a new Answer.'
      end
    end

    scenario 'invalid answer does not appears
      for all users who are on the same question page' do
      Capybara.using_session('user') do
        login(user)
        visit question_path(question1)
      end

      Capybara.using_session('guest') do
        visit question_path(question2)
      end

      Capybara.using_session('user') do
        fill_in 'Body', with: 'AnswerBody'
        fill_in 'Link name', with: 'Google'
        fill_in 'Url', with: 'invalid_url'
        attach_file 'Files',"#{Rails.root}/spec/fixtures/files/image1.jpg"

        click_on 'Create answer'

        expect(page).to have_content 'Links url invalid format'
      end

      Capybara.using_session('guest') do
        expect(page).to_not have_link 'image1.jpg'
        expect(page).to_not have_link 'Google', href: 'invalid_url'
        expect(page).to_not have_content 'AnswerBody'
        expect(page).to_not have_content 'There was a new Answer.'
      end
    end
  end
end
