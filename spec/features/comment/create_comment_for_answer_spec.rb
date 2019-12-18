require 'rails_helper'

feature 'User can create comment for answer', %q{
  In order to help current answer author
  As authenticated User
  I'd like to create comment for answer
} do

  given(:user) { create(:user) }
  given(:answer) { create(:answer) }

  describe 'Authenticated user', js: true do
    background do
      login(user)
      visit question_path(answer.question)
    end

    scenario 'create comment' do
      within('.answers') do
        expect(page).to_not have_content 'CommentBody'

        click_on 'Add comment'
        find('#comment_body').fill_in with: 'CommentBody'

        click_on 'Create comment'

        expect(page).to have_content 'CommentBody'
      end

      expect(page).to have_content 'Comment successfully created.'
    end

    scenario 'create comment with errors' do
      within('.answers') do
        click_on 'Add comment'
        click_on 'Create comment'
      end

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to create comment', js: true do
    visit question_path(answer.question)
    within('.answers') do
      expect(page).to_not have_link 'Add comment'
    end
  end
end
