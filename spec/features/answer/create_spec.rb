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
    background { visit question_path(question) }

    scenario 'answer to the question' do
      fill_in 'Body', with: 'Answer body'
      click_on I18n.t('answer.form.create_button')

      within '.answers' do
        expect(page).to have_content('Answer body')
      end
    end

    scenario 'answer with empty body to the question' do
      fill_in 'Body', with: ''
      click_on I18n.t('answer.form.create_button')

      within '.answer-errors' do
        expect(page).to have_content("Body can't be blank")
      end
    end

    scenario 'answer with attached file' do
      fill_in 'Body', with: 'Answer body'
      attach_file 'Files', Rails.root.join('spec', 'rails_helper.rb')

      click_on I18n.t('answer.form.create_button')

      within '.answers' do
        expect(page).to have_content('Answer body')
        expect(page).to have_link('rails_helper.rb')
      end
    end

    scenario 'answer with several attached file' do
      fill_in 'Body', with: 'Answer body'
      attach_file 'Files', [
        Rails.root.join('spec', 'rails_helper.rb'),
        Rails.root.join('spec', 'spec_helper.rb'),
      ]

      click_on I18n.t('answer.form.create_button')

      within '.answers' do
        expect(page).to have_content('Answer body')
        expect(page).to have_link('rails_helper.rb')
        expect(page).to have_link('spec_helper.rb')
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
