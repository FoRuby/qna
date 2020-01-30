require 'rails_helper'

feature 'User can vote for a answer', %q{
  In order to show that answer is good/bad
  As an authenticated user
  I'd like to be able to vote
} do

  given(:author) { create(:user) }
  given(:voter) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }

  describe 'User is not an author of answer', js: true do
    background do
      login(voter)
      visit question_path(question)
    end

    scenario 'votes up for answer' do
      within "#answer-#{answer.id}" do
        find('.vote-up-icon').click

        within '.rating' do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'tries to vote up for answer twice' do
      within "#answer-#{answer.id}" do
        find('.vote-up-icon').click
        find('.vote-up-icon').click

        within '.rating' do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'cancels his vote' do
      within "#answer-#{answer.id}" do
        find('.vote-up-icon').click
        find('.vote-cancel-icon').click

        within '.rating' do
          expect(page).to have_content '0'
        end
      end
    end

    scenario 'votes down for answer' do
      within "#answer-#{answer.id}" do
        find('.vote-down-icon').click

        within '.rating' do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'tries to vote down for answer twice' do
      within "#answer-#{answer.id}" do
        find('.vote-down-icon').click
        within '.rating' do
          expect(page).to have_content '-1'
        end

        find('.vote-down-icon').click
        within '.rating' do
          expect(page).to have_content '-1'
        end
      end
    end

    scenario 'tries to re-vote' do
      within "#answer-#{answer.id}" do
        find('.vote-up-icon').click
        within '.rating' do
          expect(page).to have_content '1'
        end

        find('.vote-down-icon').click
        within '.rating' do
          expect(page).to have_content '-1'
        end
      end
    end
  end

  describe 'User is author of answer', js: true do
    background do
      login(author)
      visit question_path(question)
    end

    scenario 'tries to vote up for his answer' do
      expect(page).to_not have_selector '.vote'
    end

    scenario 'tries to vote down for his answer' do
      expect(page).to_not have_selector '.vote'
    end

    scenario 'tries to cancel vote' do
      expect(page).to_not have_selector '.vote'
    end
  end

  describe 'Unauthorized user' do
    background { visit question_path(question) }

    scenario 'tries to vote up for answer' do
      expect(page).to_not have_selector '.vote'
    end

    scenario 'tries to vote down for answer' do
      expect(page).to_not have_selector '.vote'
    end

    scenario 'tries to cancel vote' do
      expect(page).to_not have_selector '.vote'
    end
  end
end
