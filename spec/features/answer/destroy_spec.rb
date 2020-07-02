require 'rails_helper'

feature 'User can destroy answer', %q{
  In order to remove answer from community
  As a authenticated user
  I'd like to ba able to destroy answer
} do
  describe 'Authenticated user' do
    given(:user) { create(:user) }
    given(:another_user) { create(:user) }

    background { sign_in(user) }

    context 'own answer' do
      context 'in own question' do
        given!(:question) { create(:question, user: user) }
        given!(:answer) { create(:answer, user: user, question: question) }

        scenario 'successful destroy' do
          visit question_path(question)

          click_on I18n.t('answer.destroy_button')

          expect(page).to have_content(I18n.t('answer.successful_destroy'))
          expect(page).to_not have_content(answer.body)
        end
      end

      context "in someone else's question" do
        given!(:question) { create(:question, user: another_user) }
        given!(:answer) { create(:answer, user: user, question: question) }

        scenario 'successful destroy' do
          visit question_path(question)

          click_on I18n.t('answer.destroy_button')

          expect(page).to have_content(I18n.t('answer.successful_destroy'))
        end
      end
    end

    context "someone else's answer" do
      context 'in own question' do
        given!(:question) { create(:question, user: user) }
        given!(:answer) { create(:answer, user: another_user, question: question) }

        scenario 'failure destroy' do
          visit question_path(question)

          expect(page).to_not have_link(I18n.t('answer.destroy_button'))
        end
      end

      context "in someone else's question" do
        given!(:question) { create(:question, user: another_user) }
        given!(:answer) { create(:answer, user: another_user, question: question) }

        scenario 'successful destroy' do
          visit question_path(question)

          expect(page).to_not have_link(I18n.t('answer.destroy_button'))
        end
      end
    end
  end
end
