# frozen_string_literal: true

require 'rails_helper'

feature 'User can sign out', "
  In order to exit from system
  As an authenticated user
  I'd like to be able to sign out
" do
  given(:user) { create(:user) }

  describe 'Registered user' do
    scenario 'tries to sign out' do
      sign_in(create(:user))

      visit questions_path

      click_on 'Logout'

      expect(page).to have_content(I18n.t('devise.sessions.signed_out'))
    end
  end

  describe 'Unregistered user' do
    scenario 'tries to sign out' do
      visit questions_path

      expect(page).to_not have_content('Log out')
      expect(page).to have_content('Login')
    end
  end
end
