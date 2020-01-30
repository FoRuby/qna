require 'rails_helper'

feature 'User can search on site', %q{
  In order to find some information
  As User
  I'd like to be able to search on site
} do

  describe 'User can search', js: true do
    given!(:user) { create(:user, email: 'test@gmail.com') }
    given!(:question) { create(:question, body: 'test') }
    given!(:answer) { create(:answer, body: 'test') }
    given!(:comment) { create(:comment, commentable: question, body: 'test') }

    before do
      ThinkingSphinx::Test.index
      visit questions_path
    end

    describe 'in SCOPE' do
      scenario 'Question' do
        ThinkingSphinx::Test.run do
          search(query: 'test', scope: 'Question')

          expect(page).to have_content(question.body)
          expect(page).to have_css(".result#question-#{question.id}")

          expect(page).to_not have_css(".result#answer-#{answer.id}")
          expect(page).to_not have_css(".result#comment-#{comment.id}")
          expect(page).to_not have_css(".result#user-#{user.id}")
        end
      end

      scenario 'Answer' do
        ThinkingSphinx::Test.run do
          search(query: 'test', scope: 'Answer')

          expect(page).to have_content(answer.body)
          expect(page).to have_css(".result#answer-#{answer.id}")

          expect(page).to_not have_css(".result#question-#{question.id}")
          expect(page).to_not have_css(".result#comment-#{comment.id}")
          expect(page).to_not have_css(".result#user-#{user.id}")
        end
      end

      scenario 'Comment' do
        ThinkingSphinx::Test.run do
          search(query: 'test', scope: 'Comment')

          expect(page).to have_content(comment.body)
          expect(page).to have_css(".result#comment-#{comment.id}")

          expect(page).to_not have_css(".result#question-#{question.id}")
          expect(page).to_not have_css(".result#answer-#{answer.id}")
          expect(page).to_not have_css(".result#user-#{user.id}")
        end
      end

      scenario 'User' do
        ThinkingSphinx::Test.run do
          search(query: 'test', scope: 'User')

          expect(page).to have_content(user.email)
          expect(page).to have_css(".result#user-#{user.id}")

          expect(page).to_not have_css(".result#question-#{question.id}")
          expect(page).to_not have_css(".result#answer-#{answer.id}")
          expect(page).to_not have_css(".result#comment-#{comment.id}")
        end
      end

      scenario 'All' do
        ThinkingSphinx::Test.run do
          search(query: 'test', scope: 'All')

          expect(page).to have_content(question.body)
          expect(page).to have_content(answer.body)
          expect(page).to have_content(comment.body)
          expect(page).to have_content(user.email)
          expect(page).to have_css(".result#question-#{question.id}")
          expect(page).to have_css(".result#answer-#{answer.id}")
          expect(page).to have_css(".result#comment-#{comment.id}")
          expect(page).to have_css(".result#user-#{user.id}")
        end
      end
    end

    scenario 'with empty search scope' do
      ThinkingSphinx::Test.run do
        fill_in 'search_query', with: 'test'
        click_on 'Search'

        expect(page).to have_content(question.body)
        expect(page).to have_content(answer.body)
        expect(page).to have_content(comment.body)
        expect(page).to have_content(user.email)
        expect(page).to have_css(".result#question-#{question.id}")
        expect(page).to have_css(".result#answer-#{answer.id}")
        expect(page).to have_css(".result#comment-#{comment.id}")
        expect(page).to have_css(".result#user-#{user.id}")
      end
    end

    scenario 'with empty search query' do
      ThinkingSphinx::Test.run do
        fill_in 'search_query', with: ''
        click_on 'Search'

        expect(page).to have_content(question.body)
        expect(page).to have_content(answer.body)
        expect(page).to have_content(comment.body)
        expect(page).to have_content(user.email)
        expect(page).to have_css(".result#question-#{question.id}")
        expect(page).to have_css(".result#answer-#{answer.id}")
        expect(page).to have_css(".result#comment-#{comment.id}")
        expect(page).to have_css(".result#user-#{user.id}")
      end
    end
  end
end
