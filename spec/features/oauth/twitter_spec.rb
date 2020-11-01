require 'rails_helper'

feature 'User can authorization throw Twitter', %q{
  In order to login to site
  As a authenticated user
  I'd like to ba able to login throw Twitter account
} do

  background do
    OmniAuth.config.mock_auth[:twitter] = auth

    clear_emails
  end

  describe 'Unauthenticated user' do
    given(:auth) { OmniAuth::AuthHash.new(provider: 'twitter', uid: '123456') }

    scenario 'register using Twitter account' do
      visit new_user_session_path

      expect(page).to have_link('Sign in with Twitter')
      click_on 'Sign in with Twitter'

      fill_in 'Email', with: 'new@user.com'
      click_on 'Send confirmation instructions'

      open_email('new@user.com')
      expect(current_email).to have_content 'You can confirm your account email through the link below'

      current_email.click_link 'Confirm my account'
      expect(page).to have_content 'Your email address has been successfully confirmed.'

      click_on 'Sign in with Twitter'

      expect(page).to have_content('Successfully authenticated from Twitter account.')
      expect(page).to have_content('new@user.com')
      expect(page).to have_content('Logout')
    end

    scenario 'user can not be authenticated' do
      OmniAuth.config.mock_auth[:twitter] = :invalid_credentials

      visit new_user_session_path

      expect(page).to have_link('Sign in with Twitter')
      click_on 'Sign in with Twitter'

      expect(page).to have_content('Could not authenticate you from Twitter because "Error"')
      expect(page).to_not have_content('new@user.com')
      expect(page).to have_link('Login')
    end

    scenario 'user can not be authenticated without confirmation email' do
      visit new_user_session_path

      expect(page).to have_link('Sign in with Twitter')
      click_on 'Sign in with Twitter'

      fill_in 'Email', with: 'new@user.com'
      click_on 'Send confirmation instructions'

      open_email('new@user.com')
      expect(current_email).to have_content 'You can confirm your account email through the link below'

      visit new_user_session_path
      click_on 'Sign in with Twitter'

      expect(page).to have_content('You have to confirm your email address before continuing.')
      expect(page).to_not have_content('new@user.com')
      expect(page).to have_content('Login')
    end

    scenario 'user have to input email for confirm email' do
      visit new_user_session_path

      expect(page).to have_link('Sign in with Twitter')
      click_on 'Sign in with Twitter'

      fill_in 'Email', with: ''
      click_on 'Send confirmation instructions'

      expect(page).to have_content('Authorization failure')
      expect(page).to_not have_content('new@user.com')
      expect(page).to have_content('Login')
    end
  end

  describe 'Exist user' do
    given!(:user) { create(:user, confirmed_at: DateTime.now) }
    given!(:authorization) { create(:authorization, provider: 'twitter', uid: '123456', user: user) }
    given(:auth) { OmniAuth::AuthHash.new(provider: 'twitter', uid: '123456') }

    scenario 'authenticated using Twitter account' do
      visit new_user_session_path

      expect(page).to have_link('Sign in with Twitter')
      click_on 'Sign in with Twitter'

      expect(page).to have_content('Successfully authenticated from Twitter account.')
      expect(page).to have_content(user.email)
      expect(page).to have_content('Logout')
    end

    scenario 'user can not be authenticated by error' do
      OmniAuth.config.mock_auth[:twitter] = :invalid_credentials

      visit new_user_session_path

      expect(page).to have_link('Sign in with Twitter')
      click_on 'Sign in with Twitter'

      expect(page).to have_content('Could not authenticate you from Twitter because "Error"')
      expect(page).to_not have_content(user.email)
      expect(page).to have_content('Login')
    end
  end
end
