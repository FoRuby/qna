module FeatureHelpers
  def login(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    within '.actions' do
      click_on 'Sign in'
    end
  end

  def register(user)
    visit new_user_registration_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    within '.actions' do
      click_on 'Sign up'
    end
  end
end
