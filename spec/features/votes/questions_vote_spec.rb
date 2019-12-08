require 'rails_helper'

feature 'User can vote for a question', %q{
  In order to show that question is good/bad
  As an authenticated user
  I'd like to be able to vote
} do

  given(:author) { create(:user) }
  given(:voter) { create(:user) }
  given!(:question) { create(:question, user: author) }

  describe 'User is not an author of question', js: true do
    background do
      login(voter)
      visit question_path(question)
    end

    scenario 'votes up for question' do
      within "#question-#{question.id}" do
        find('.vote-up-icon').click

        within '.rating' do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'tries to vote up for question twice' do
      within "#question-#{question.id}" do
        find('.vote-up-icon').click
        find('.vote-up-icon').click

        within '.rating' do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'cancels his vote' do
      within "#question-#{question.id}" do
        find('.vote-up-icon').click
        find('.vote-cancel-icon').click

        within '.rating' do
          expect(page).to have_content '0'
        end
      end
    end

    scenario 'votes down for question' do
      within "#question-#{question.id}" do
        find('.vote-down-icon').click

        within '.rating' do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'tries to vote down for question twice' do
      within "#question-#{question.id}" do
        find('.vote-down-icon').click
        find('.vote-down-icon').click

        within '.rating' do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'can re-votes' do
      within "#question-#{question.id}" do
        find('.vote-up-icon').click
        find('.vote-cancel-icon').click
        find('.vote-down-icon').click

        within '.rating' do
          expect(page).to have_content '-1'
        end
      end
    end
  end

  describe 'User is author of question tries to', js: true do
    background do
      login(author)
      visit questions_path
    end

    scenario 'vote up for his question' do
      expect(page).to_not have_selector '.vote'
    end

    scenario 'vote down for his question' do
      expect(page).to_not have_selector '.vote'
    end

    scenario 'cancel vote' do
      expect(page).to_not have_selector '.vote'
    end
  end

  describe 'Unauthorized user tries to' do
    background { visit questions_path }

    scenario 'vote up for question' do
      expect(page).to_not have_selector '.vote'
    end

    scenario 'vote down for question' do
      expect(page).to_not have_selector '.vote'
    end

    scenario 'cancel vote' do
      expect(page).to_not have_selector '.vote'
    end
  end
end
