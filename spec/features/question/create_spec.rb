require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from community
  As a authenticated user
  I'd like to ba able to ask the question
} do
  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background { sign_in(user) }

    scenario 'ask question' do
      visit questions_path
      click_on I18n.t('question.new_button')

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on I18n.t('question.form.create_button')

      expect(page).to have_content(I18n.t('question.successful_create'))
      expect(page).to have_content('Test question')
      expect(page).to have_content('text text text')
    end
  end

  describe 'Unauthenticated user' do
    scenario 'ask question' do
      visit questions_path
      click_on I18n.t('question.new_button')

      expect(page).to have_content(I18n.t('devise.failure.unauthenticated'))
    end
  end
end
