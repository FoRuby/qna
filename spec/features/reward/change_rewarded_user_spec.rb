require 'rails_helper'

feature 'When changing the best answer, the award
         also goes to the author of the new best answer', %q{
  In order to reward correct author of the best answer
  As an question's author
  I'd like to the award went to the author of the new best answer
} do

  given!(:question) { create(:question) }
  given!(:new_best_answer) { create(:answer, question: question) }
  given!(:old_best_answer) { create(:answer, question: question) }
  given!(:reward) { create(:reward, question: question, user: old_best_answer.user) }

  describe 'Changing rewarded user', js: true do
    background do
      login(question.user)
      visit question_path(question)
      click_on 'Select best answer'

      mark_link = find("#edit-best-answer-icon-#{new_best_answer.id}")
      mark_link.click

      click_on 'Sign out'
    end

    scenario 'Take reward from old best answer user' do
      login(old_best_answer.user)
      visit rewards_path

      expect(page).to_not have_content reward.title
      expect(page).to_not have_content reward.question.title
    end

    scenario 'Passing reward to new best answer user' do
      login(new_best_answer.user)
      visit rewards_path

      expect(page).to have_content reward.title
      expect(page).to have_content reward.question.title
    end
  end
end
