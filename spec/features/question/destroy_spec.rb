require 'rails_helper'

feature 'User can destroy question', %q{
  In order to remove question from community
  As a authenticated user
  I'd like to ba able to destroy question
} do
  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background { sign_in(user) }

    context 'own question' do
      given!(:question) { create(:question, user: user) }

      scenario 'successful destroy' do
        visit question_path(question)

        click_on I18n.t('question.destroy_button')

        expect(page).to have_content(I18n.t('question.successful_destroy'))
        expect(page).to_not have_content(question.title)
        expect(page).to_not have_content(question.body)
      end
    end

    context "someone else's question" do
      given(:another_user) { create(:user) }
      given!(:question) { create(:question, user: another_user) }

      scenario 'failure destroy' do
        visit question_path(question)

        expect(page).to_not have_content(I18n.t('question.destroy_button'))
      end
    end
  end

  describe 'Unauthenticated user' do
    given(:user) { create(:user) }
    given!(:question) { create(:question, user: user) }

    scenario 'failure destroy' do
      visit question_path(question)

      expect(page).to_not have_content(I18n.t('question.destroy_button'))
    end
  end
end
