require 'rails_helper'

feature 'When user creates a new comment,
  then this comment appears for all users,
  who are on the same question page' do

  given(:user1) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question) }
  given(:question1) { create(:question_with_answers) }
  given(:question2) { create(:question_with_answers) }

  describe 'Question', js: true do
    scenario 'comment appears for all users
      who are on the same question page' do
      Capybara.using_session('user1') do
        login(user1)
        visit question_path(question1)

        expect(page).to_not have_content 'CommentBody'
      end

      Capybara.using_session('guest') do
        visit question_path(question1)

        expect(page).to_not have_content 'CommentBody'
      end

      Capybara.using_session('user1') do
        within('.question') do
          click_on 'Add comment'
          find('#comment_body').fill_in with: 'CommentBody'

          click_on 'Create comment'

          expect(page).to have_content 'CommentBody'
        end
      end

      Capybara.using_session('guest') do
        within('.question') do
          expect(page).to have_content 'CommentBody'
        end

        expect(page).to have_content 'There was a new Comment.'
      end
    end

    scenario 'comment does not appears for user
      who are not on the same question page' do
      Capybara.using_session('user1') do
        login(user1)
        visit question_path(question1)
      end

      Capybara.using_session('guest') do
        visit question_path(question2)
      end

      Capybara.using_session('user1') do
        within('.question') do
          click_on 'Add comment'
          find('#comment_body').fill_in with: 'CommentBody'
          click_on 'Create comment'

          expect(page).to have_content 'CommentBody'
        end
      end

      Capybara.using_session('guest') do
        within('.question') do
          expect(page).to_not have_content 'CommentBody'
          expect(page).to_not have_content 'There was a new Comment.'
        end
      end
    end
  end

  describe 'Answer', js: true do
    scenario 'comment appears for all users
      who are on the same question page' do
      Capybara.using_session('user1') do
        login(user1)
        visit question_path(question1)

        expect(page).to_not have_content 'CommentBody'
      end

      Capybara.using_session('guest') do
        visit question_path(question1)

        expect(page).to_not have_content 'CommentBody'
      end

      Capybara.using_session('user1') do
        within('.answers') do
          click_on 'Add comment'
          find('#comment_body').fill_in with: 'CommentBody'

          click_on 'Create comment'

          expect(page).to have_content 'CommentBody'
        end
      end

      Capybara.using_session('guest') do
        within('.answers') do
          expect(page).to have_content 'CommentBody'
        end

        expect(page).to have_content 'There was a new Comment.'
      end
    end

    scenario 'comment does not appears for user
      who are not on the same question page' do
      Capybara.using_session('user1') do
        login(user1)
        visit question_path(question1)

        expect(page).to_not have_content 'CommentBody'
      end

      Capybara.using_session('guest') do
        visit question_path(question2)
      end

      Capybara.using_session('user1') do
        within('.answers') do
          click_on 'Add comment'
          find('#comment_body').fill_in with: 'CommentBody'
          click_on 'Create comment'

          expect(page).to have_content 'CommentBody'
        end
      end

      Capybara.using_session('guest') do
        within('.answers') do
          expect(page).to_not have_content 'CommentBody'
          expect(page).to_not have_content 'There was a new Comment.'
        end
      end
    end

    scenario 'invalid comment does not appears for user
      who are not on the same question page' do
      Capybara.using_session('user1') do
        login(user1)
        visit question_path(question1)

        expect(page).to_not have_content 'CommentBody'
      end

      Capybara.using_session('guest') do
        visit question_path(question2)
      end

      Capybara.using_session('user1') do
        within('.answers') do
          click_on 'Add comment'
          find('#comment_body').fill_in with: 'CommentBody'
          click_on 'Create comment'

          expect(page).to have_content 'CommentBody'
        end
      end

      Capybara.using_session('guest') do
        within('.answers') do
          expect(page).to_not have_content 'CommentBody'
          expect(page).to_not have_content 'There was a new Comment.'
        end
      end
    end

    scenario 'authenticated user try to leave comment for appearing answer' do
      Capybara.using_session('user1') do
        login(user1)
        visit question_path(question)

        expect(page).to_not have_content 'AnswerBody'
        expect(page).to_not have_content 'CommentBody'
      end

      Capybara.using_session('user2') do
        login(user2)
        visit question_path(question)

        expect(page).to_not have_content 'AnswerBody'
        expect(page).to_not have_content 'CommentBody'
      end

      Capybara.using_session('user1') do
        fill_in 'Body', with: 'AnswerBody'

        click_on 'Create answer'
      end

      Capybara.using_session('user2') do
        within('.answers') do
          click_on 'Add comment'
          find('#comment_body').fill_in with: 'CommentBody'

          click_on 'Create comment'

          expect(page).to have_content 'CommentBody'
        end
      end

      Capybara.using_session('user1') do
        expect(page).to have_content 'There was a new Comment.'
        expect(page).to have_content 'CommentBody'
      end
    end

    scenario 'unauthenticated user can not to leave comment for appearing answer' do
      Capybara.using_session('user1') do
        login(user1)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user1') do
        fill_in 'Body', with: 'AnswerBody'

        click_on 'Create answer'
      end

      Capybara.using_session('guest') do
        within('.answers') do
          expect(page).to_not have_link 'Add comment'
        end
      end
    end
  end
end
