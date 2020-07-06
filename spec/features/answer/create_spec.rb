require 'rails_helper'

feature 'User can create answer', %q{
  In order to make answer
  As a authenticated user
  I'd like to ba able to answer to the question
} do
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }

    background { sign_in(user) }

    scenario 'answer to the question' do
      visit question_path(question)

      fill_in 'Body', with: 'Answer body'
      click_on I18n.t('answer.form.create_button')

      within '.answers' do
        expect(page).to have_content('Answer body')
      end
    end

    scenario 'answer with empty body to the question' do
      visit question_path(question)

      fill_in 'Body', with: ''
      click_on I18n.t('answer.form.create_button')

      within '.answer-errors' do
        expect(page).to have_content("Body can't be blank")
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'ask question' do
      visit question_path(question)

      fill_in 'Body', with: 'Answer body'
      click_on I18n.t('answer.form.create_button')

      expect(page).to have_content(I18n.t('devise.failure.unauthenticated'))
    end
  end
end
