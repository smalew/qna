require 'rails_helper'

feature 'User can edit answer', %q{
  In order to change answer
  As a authenticated user
  I'd like to ba able to edit answer to the question
} do
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }
    given!(:answer) { create(:answer, question: question, user: user) }

    background { sign_in(user) }
    background { visit question_path(question) }

    scenario 'answer to the question' do
      within '.answers' do
        click_on I18n.t('answer.form.edit_button')

        fill_in 'Body', with: 'New Answer body'

        click_on I18n.t('answer.form.save_button')

        expect(page).to have_content('New Answer body')
        expect(page).to_not have_content(answer.body)
        expect(page).to_not have_selector('textarea')
      end
    end

    scenario 'answer with empty body to the question' do
      within '.answers' do
        click_on I18n.t('answer.form.edit_button')

        fill_in 'Body', with: ''

        click_on I18n.t('answer.form.save_button')

        expect(page).to have_content(answer.body)
        expect(page).to have_selector('textarea')
      end

      within '.answer-errors' do
        expect(page).to have_content("Body can't be blank")
      end
    end
  end

  describe 'Unauthenticated user' do
    background { visit question_path(question) }

    scenario 'ask question' do
      within '.answers' do
        expect(page).to_not have_link(I18n.t('answer.form.edit_button'))
      end
    end
  end
end
