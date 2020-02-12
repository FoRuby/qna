require 'rails_helper'

feature 'User can mark answer as best', %q{
  In order to select best answer
  As author of question
  I'd like to be able to mark answer as best
} do

  given(:user) { create(:user) }
  given(:question) { create(:question_with_answers, answers_count: 3) }
  given(:first_answer) { question.answers.first }
  given(:second_answer) { question.answers.second }
  given(:third_answer) { question.answers.last }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Select best answer'
  end

  scenario "Authenticated user can not select best answer of other user's question" do
    login(user)
    visit question_path(question)

    expect(page).to_not have_link 'Select best answer'
  end

  describe 'Authenticated question author', js: true do
    background do
      login(question.user)
      visit question_path(question)
    end

    scenario 'tries to select best answer' do
      click_on 'Select best answer'

      mark_link = find("#edit-best-answer-icon-#{second_answer.id}")
      mark_link.click

      expect(page).to have_content 'Best answer selected.'
      expect(first('.answers')).to have_css("#best-answer-icon-#{second_answer.id}")
      expect(first('.answers')).to_not have_selector('.edit-best-answer-icon')
      expect(first('.answers')).to have_content first_answer.body.to_s
      expect(first('.answers')).to have_content third_answer.body.to_s
    end

    scenario 'tries to select best answer repeatedly' do
      click_on 'Select best answer'

      mark_link = find("#edit-best-answer-icon-#{first_answer.id}")
      mark_link.click

      expect(page).to have_content 'Best answer selected.'
      expect(page).to_not have_selector('.edit-best-answer-icon')
      expect(first('.answers')).to have_css("#best-answer-icon-#{first_answer.id}")
      expect(first('.answers')).to have_content second_answer.body.to_s
      expect(first('.answers')).to have_content third_answer.body.to_s
    end

    scenario 'tries to cancel best answer selection' do
      click_on 'Select best answer'

      expect(page).to have_css("#edit-best-answer-icon-#{first_answer.id}")
      expect(page).to have_css("#edit-best-answer-icon-#{second_answer.id}")
      expect(page).to have_css("#edit-best-answer-icon-#{third_answer.id}")

      click_on 'Select best answer'

      expect(page).to_not have_css("#edit-best-answer-icon-#{first_answer.id}")
      expect(page).to_not have_css("#edit-best-answer-iconn-#{second_answer.id}")
      expect(page).to_not have_css("#edit-best-answer-icon-#{third_answer.id}")
    end
  end

  scenario 'Answers are ordered correct', js: true do
    login(question.user)
    visit question_path(question)

    click_on 'Select best answer'
    find("#edit-best-answer-icon-#{second_answer.id}").click

    expect(find("#answer-#{second_answer.id}")).to have_css("#best-answer-icon-#{second_answer.id}")
    expect(find("#answer-#{second_answer.id}")).to have_content second_answer.body.to_s

    expect(find("#answer-#{first_answer.id}")).to have_content first_answer.body.to_s
    expect(find("#answer-#{third_answer.id}")).to have_content third_answer.body.to_s
  end
end
