require 'rails_helper'

feature 'User can add reward to question', %q{
  In order to reward author of the best answer
  As an question's author
  I'd like to be able to set a reward
} do

  given(:user) { create(:user) }

  background do
    login(user)
    visit new_question_path
  end

  scenario "Question's author adds reward when asks question" do
    fill_in 'Title', with: 'TestTitle'
    fill_in 'Body', with: 'TestBody'

    fill_in 'Reward title', with: 'TestReward'
    attach_file 'Image', "#{Rails.root}/spec/fixtures/files/image1.jpg"

    click_on 'Ask'

    expect(page).to have_content 'Your question successfully created'
  end
end
