# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign in', "
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in
" do
  given(:user) { create(:user) }

  describe 'Registered user' do
    scenario 'tries to sign in' do
      manual_login(create(:user))

      expect(page).to have_content(I18n.t('devise.sessions.signed_in'))
      expect(page).to_not have_content('Login')
    end
  end

  describe 'Unregistered user' do
    background { visit new_user_session_path }

    scenario 'tries to sign in without password' do
      fill_in 'Email', with: 'Some email'
      fill_in 'Password', with: ''
      click_on 'Log in'

      expect(page).to have_content(I18n.t('devise.failure.invalid', authentication_keys: 'Email'))
      expect(page).to have_content('Login')
      expect(page).to_not have_content('Log out')
    end

    scenario 'tries to sign in without email' do
      fill_in 'Email', with: ''
      fill_in 'Password', with: '123456789'
      click_on 'Log in'

      expect(page).to have_content(I18n.t('devise.failure.invalid', authentication_keys: 'Email'))
      expect(page).to have_content('Login')
      expect(page).to_not have_content('Log out')
    end
  end
end
