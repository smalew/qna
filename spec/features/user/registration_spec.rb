# frozen_string_literal: true

require 'rails_helper'

feature 'User can register', "
  In order to login and ask question
  As an authenticated user
  I'd like to be able to register
" do
  describe 'Registered user' do
    given(:user) { create(:user) }

    scenario 'tries to register' do
      sign_in(create(:user))

      visit questions_path

      expect(page).to_not have_content('Register')
    end
  end

  describe 'Unregistered user' do
    context 'tries to register' do
      scenario 'with correct parameters' do
        visit questions_path

        click_on 'Register'

        fill_in :user_email, with: 'test@mail.com'
        fill_in :user_password, with: '123456789'
        fill_in :user_password_confirmation, with: '123456789'

        click_on 'Sign up'

        expect(page).to have_content(I18n.t('devise.registrations.signed_up'))
        expect(page).to_not have_content('Login')
        expect(page).to_not have_content('Register')
      end

      scenario 'with different password confirmation' do
        visit questions_path

        click_on 'Register'

        fill_in :user_email, with: 'test@mail.com'
        fill_in :user_password, with: '123456789'
        fill_in :user_password_confirmation, with: '1'

        click_on 'Sign up'

        expect(page).to have_content(I18n.t('errors.messages.not_saved.one', resource: :user))
        expect(page).to have_content("Password confirmation doesn't match Password")
      end
    end
  end
end
