require 'rails_helper'

feature 'User can authorization throw github', %q{
  In order to login to site
  As a authenticated user
  I'd like to ba able to login throw github account
} do

  before { OmniAuth.config.mock_auth[:github] = auth }

  describe 'Unauthenticated user' do
    given(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: 'new@user.com' }) }

    scenario 'register using github account' do
      visit new_user_session_path

      expect(page).to have_link('Sign in with GitHub')
      click_on 'Sign in with GitHub'

      expect(page).to have_content('Successfully authenticated from GitHUb account.')
      expect(page).to have_content('new@user.com')
      expect(page).to have_content('Logout')
    end

    scenario 'user can not be authenticated' do
      OmniAuth.config.mock_auth[:github] = :invalid_credentials

      visit new_user_session_path

      expect(page).to have_link('Sign in with GitHub')
      click_on 'Sign in with GitHub'

      expect(page).to have_content('Could not authenticate you from GitHub because "Error"')
      expect(page).to_not have_content('new@user.com')
      expect(page).to have_link('Login')
    end
  end

  describe 'Exist user' do
    given(:user) { create(:user) }
    given(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123456', info: { email: user.email }) }

    scenario 'authenticated using github account' do
      visit new_user_session_path

      expect(page).to have_link('Sign in with GitHub')
      click_on 'Sign in with GitHub'

      expect(page).to have_content('Successfully authenticated from GitHUb account.')
      expect(page).to have_content(user.email)
      expect(page).to have_content('Logout')
    end

    scenario 'user can not be authenticated by error' do
      OmniAuth.config.mock_auth[:github] = :invalid_credentials

      visit new_user_session_path

      expect(page).to have_link('Sign in with GitHub')
      click_on 'Sign in with GitHub'

      expect(page).to have_content('Could not authenticate you from GitHub because "Error"')
      expect(page).to_not have_content(user.email)
      expect(page).to have_content('Login')
    end
  end
end
