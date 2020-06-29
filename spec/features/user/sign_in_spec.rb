require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in
} do
  given(:user) { create(:user) }

  describe 'Registered user' do
    scenario 'tries to sign in' do
      sign_in(create(:user))

      expect(page).to have_content(I18n.t('devise.sessions.signed_in'))
    end
  end

  describe 'Unregistered user' do
    background { visit new_user_session_path }

    scenario 'tries to sign in without password' do
      fill_in 'Email', with: 'Some email'
      fill_in 'Password', with: ''
      click_on 'Log in'

      expect(page).to have_content(I18n.t('devise.failure.invalid', authentication_keys: 'Email'))
    end

    scenario 'tries to sign in without email' do
      fill_in 'Email', with: ''
      fill_in 'Password', with: '123456789'
      click_on 'Log in'

      expect(page).to have_content(I18n.t('devise.failure.invalid', authentication_keys: 'Email'))
    end
  end
end
