require 'rails_helper'

feature 'When user creates a new question,
  then this question appears for all users,
  who are on questions#index page' do

  given(:user) { create(:user) }

  context 'mulitple sessions', js: true do
    scenario 'question appears for all users who are on questions#index page' do
      Capybara.using_session('user') do
        login(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'Title', with: 'TestQuestion'
        fill_in 'Body', with: 'TestBody'
        click_on 'Ask'

        expect(page).to have_content 'TestQuestion'
        expect(page).to have_content 'TestBody'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'TestQuestion'
        expect(page).to have_content 'There was a new Question. Answer it first.'
      end
    end
  end
end
