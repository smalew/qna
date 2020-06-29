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

      fill_in 'Title', with: 'Title question'
      fill_in 'Body', with: 'Body question'
      click_on I18n.t('question.form.create_button')

      expect(page).to have_content(I18n.t('question.successful_create'))
      expect(page).to have_content('Title question')
      expect(page).to have_content('Body question')
    end

    scenario 'ask question with empty title' do
      visit questions_path
      click_on I18n.t('question.new_button')

      fill_in 'Title', with: ''
      fill_in 'Body', with: 'Body question'
      click_on I18n.t('question.form.create_button')

      expect(page).to have_content("Title can't be blank")
    end

    scenario 'ask question with empty body' do
      visit questions_path
      click_on I18n.t('question.new_button')

      fill_in 'Title', with: 'Title question'
      fill_in 'Body', with: ''
      click_on I18n.t('question.form.create_button')

      expect(page).to have_content("Body can't be blank")
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
