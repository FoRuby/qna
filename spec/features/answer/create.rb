require 'rails_helper'

feature 'User can create answer for current question', %q{
  In order to help current question author
  As User
  I'd like to create answer for current question
} do

  given(:user) { User.create(email: 'user@example.com', password: 'foobar') }
  given(:question) { FactoryBot.create(:question_with_index) }
  given(:answer) { Answer.create(body: 'NewAnswerBody', question_id: question) }

  describe 'Authenticated user' do
    background do
      login(user)
      visit question_path(question)
    end

    scenario 'tries to create answer for current question with correct params' do
      fill_in 'Body', with: answer.body
      click_on 'Answer'

      expect(page).to have_content answer.body
    end

    scenario 'tries to create answer for current question with incorrect params' do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to create answer for current question' do
    visit question_path(question)

    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing'
  end
end
