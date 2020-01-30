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
          search(search_string: 'test', search_scope: 'Question')

          expect(page).to have_content(question.body)
        end
      end

      scenario 'Answer' do
        ThinkingSphinx::Test.run do
          search(search_string: 'test', search_scope: 'Answer')

          expect(page).to have_content(answer.body)
        end
      end

      scenario 'Comment' do
        ThinkingSphinx::Test.run do
          search(search_string: 'test', search_scope: 'Comment')

          expect(page).to have_content(comment.body)
        end
      end

      scenario 'User' do
        ThinkingSphinx::Test.run do
          search(search_string: 'test', search_scope: 'User')

          expect(page).to have_content(user.email)
        end
      end

      scenario 'All' do
        ThinkingSphinx::Test.run do
          search(search_string: 'test', search_scope: 'All')

          expect(page).to have_content(question.body)
          expect(page).to have_content(answer.body)
          expect(page).to have_content(comment.body)
          expect(page).to have_content(user.email)
        end
      end
    end

    scenario 'in all with empty search result' do
      ThinkingSphinx::Test.run do
        search(search_string: 'foobar', search_scope: 'All')

        expect(page).to have_content('Nothing was found.')
      end
    end

    scenario 'in all with empty search query' do
      ThinkingSphinx::Test.run do
        search(search_string: '', search_scope: 'All')

        expect(page).to have_content('Invalid query')
        expect(page).to have_current_path(questions_path)
      end
    end
  end
end
