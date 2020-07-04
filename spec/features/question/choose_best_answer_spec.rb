require 'rails_helper'

feature 'User can choose best answer', %q{
  In order to help community with best answer
  As a authenticated user
  I'd like to ba able to choose best answer
} do
  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background { sign_in(user) }

    given!(:answer) { create(:answer, question: question)}

    context 'question owner', js: true do
      context 'when only one answer' do
        given(:question) { create(:question, user: user) }

        scenario 'can choose best answer' do
          visit question_path(question)

          within '.answers' do
            click_on I18n.t('answer.choose_as_best')
          end

          within '#best-answer' do
            expect(page).to have_content(answer.body)
          end
        end
      end

      context 'when best answer already exist' do
        given(:question) { create(:question, user: user) }
        given!(:another_answer) { create(:answer, question: question)}

        background { question.update(best_answer: answer)}

        scenario 'can choose another best answer' do
          visit question_path(question)

          within "#answer-id-#{another_answer.id}" do
            click_on I18n.t('answer.choose_as_best')
          end

          within '#best-answer' do
            expect(page).to have_content(another_answer.body)
          end
        end
      end
    end

    context 'is not question owner' do
      given(:question) { create(:question) }

      scenario 'can not choose best answer' do
        visit question_path(question)

        within '.answers' do
          expect(page).to_not have_link(I18n.t('answer.choose_as_best'))
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    given(:question) { create(:question) }

    scenario 'choose best answer' do
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link(I18n.t('answer.choose_as_best'))
      end
    end
  end
end