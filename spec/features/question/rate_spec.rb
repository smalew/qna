require 'rails_helper'

feature 'User can rate up question', %q{
  In order to rate questions
  As a authenticated user
  I'd like to ba able to rate the question
} do
  given(:user) { create(:user) }

  describe 'Authenticated user', js: true do
    given!(:question) { create(:question, user: author) }

    background { sign_in(user) }
    background { visit question_path(question) }

    context 'when is not question owner' do
      given(:author) { create(:user) }

      scenario 'can rate up' do
        within "#question-#{question.id}" do
          within '.rate-actions' do
            expect(page).to have_link(I18n.t('rate.up'))
            expect(page).to have_link(I18n.t('rate.down'))

            click_on I18n.t('rate.up')

            expect(page).to_not have_link(I18n.t('rate.up'))
            expect(page).to_not have_link(I18n.t('rate.down'))
            expect(page).to have_link(I18n.t('rate.cancel'))
          end

          within '.rate-value' do
            expect(page).to have_content('1')
          end
        end
      end

      scenario 'can rate down' do
        within "#question-#{question.id}" do
          within '.rate-actions' do
            expect(page).to have_link(I18n.t('rate.up'))
            expect(page).to have_link(I18n.t('rate.down'))

            click_on I18n.t('rate.down')

            expect(page).to_not have_link(I18n.t('rate.up'))
            expect(page).to_not have_link(I18n.t('rate.down'))
            expect(page).to have_link(I18n.t('rate.cancel'))
          end

          within '.rate-value' do
            expect(page).to have_content('-1')
          end
        end
      end

      context 'with own rate' do
        given!(:rate) { create(:rate, ratable: question, user: user) }

        background { visit question_path(question) }

        scenario 'can cancel rate for' do
          within "#question-#{question.id}" do
            within '.rate-actions' do
              expect(page).to_not have_link(I18n.t('rate.up'))
              expect(page).to_not have_link(I18n.t('rate.down'))

              click_on I18n.t('rate.cancel')

              expect(page).to have_link(I18n.t('rate.up'))
              expect(page).to have_link(I18n.t('rate.down'))
            end

            within '.rate-value' do
              expect(page).to have_content('0')
            end
          end
        end
      end

      context 'with someone else rate' do
        given!(:rate) { create(:rate, ratable: question) }

        background { visit question_path(question) }

        scenario 'can cancel rate for' do
          within "#question-#{question.id}" do
            within '.rate-actions' do
              expect(page).to have_link(I18n.t('rate.up'))
              expect(page).to have_link(I18n.t('rate.down'))
              expect(page).to_not have_link(I18n.t('rate.cancel'))
            end

            within '.rate-value' do
              expect(page).to have_content('-1')
            end
          end
        end
      end
    end

    context "own question" do
      given(:author) { user }

      scenario 'can not rate' do
        within "#question-#{question.id}" do
          expect(page).to_not have_css('.rate-actions')

          within '.rate-value' do
            expect(page).to have_content('0')
          end
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    given!(:question) { create(:question) }

    background { visit question_path(question) }

    scenario 'can not rates' do
      within "#question-#{question.id}" do
        expect(page).to_not have_css('.rate-actions')

        within '.rate-value' do
          expect(page).to have_content('0')
        end
      end
    end
  end
end
