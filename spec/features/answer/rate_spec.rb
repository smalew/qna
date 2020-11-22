# frozen_string_literal: true

require 'rails_helper'

feature 'User can rate up answer', "
  In order to rate answer
  As a authenticated user
  I'd like to ba able to rate the answer
" do
  given(:user) { create(:user) }

  describe 'Authenticated user', js: true do
    given!(:question) { create(:question, user: author) }
    given!(:answer) { create(:answer, question: question, user: author) }

    background { sign_in(user) }
    background { visit question_path(question) }

    context 'when is not answer owner' do
      given(:author) { create(:user) }

      scenario 'can rate up' do
        within '.answers' do
          within "#answer-id-#{answer.id}" do
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
      end

      scenario 'can rate down' do
        within '.answers' do
          within "#answer-id-#{answer.id}" do
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
      end

      context 'with own rate' do
        given!(:rate) { create(:rate, ratable: answer, user: user) }

        background { visit question_path(question) }

        scenario 'can cancel rate for' do
          within '.answers' do
            within "#answer-id-#{answer.id}" do
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
      end

      context 'with someone else rate' do
        given!(:rate) { create(:rate, ratable: answer) }

        background { visit question_path(question) }

        scenario 'can cancel rate for' do
          within '.answers' do
            within "#answer-id-#{answer.id}" do
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

      context 'with another answer' do
        given!(:another_answer) { create(:answer, question: question) }

        background { visit question_path(question) }

        scenario 'can rate up correct answer' do
          within '.answers' do
            within "#answer-id-#{answer.id}" do
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

            within "#answer-id-#{another_answer.id}" do
              within '.rate-actions' do
                expect(page).to have_link(I18n.t('rate.up'))
                expect(page).to have_link(I18n.t('rate.down'))
                expect(page).to_not have_link(I18n.t('rate.cancel'))
              end

              within '.rate-value' do
                expect(page).to have_content('0')
              end
            end
          end
        end

        scenario 'can rate down correct answer' do
          within '.answers' do
            within "#answer-id-#{answer.id}" do
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

            within "#answer-id-#{another_answer.id}" do
              within '.rate-actions' do
                expect(page).to have_link(I18n.t('rate.up'))
                expect(page).to have_link(I18n.t('rate.down'))
                expect(page).to_not have_link(I18n.t('rate.cancel'))
              end

              within '.rate-value' do
                expect(page).to have_content('0')
              end
            end
          end
        end

        context 'with someone else rate' do
          given!(:rate) { create(:rate, ratable: answer) }

          background { visit question_path(question) }

          scenario 'can cancel rate for correct answer' do
            within '.answers' do
              within "#answer-id-#{answer.id}" do
                within '.rate-actions' do
                  expect(page).to have_link(I18n.t('rate.up'))
                  expect(page).to have_link(I18n.t('rate.down'))
                  expect(page).to_not have_link(I18n.t('rate.cancel'))
                end

                within '.rate-value' do
                  expect(page).to have_content('-1')
                end
              end

              within "#answer-id-#{another_answer.id}" do
                within '.rate-actions' do
                  expect(page).to have_link(I18n.t('rate.up'))
                  expect(page).to have_link(I18n.t('rate.down'))
                  expect(page).to_not have_link(I18n.t('rate.cancel'))
                end

                within '.rate-value' do
                  expect(page).to have_content('0')
                end
              end
            end
          end
        end
      end
    end

    context 'own answer' do
      given(:author) { user }

      scenario 'can not rate' do
        within '.answers' do
          within "#answer-id-#{answer.id}" do
            expect(page).to_not have_css('.rate-actions')

            within '.rate-value' do
              expect(page).to have_content('0')
            end
          end
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    given!(:question) { create(:question) }
    given!(:answer) { create(:answer, question: question) }

    background { visit question_path(question) }

    scenario 'can not rates' do
      within '.answers' do
        within "#answer-id-#{answer.id}" do
          expect(page).to_not have_css('.rate-actions')

          within '.rate-value' do
            expect(page).to have_content('0')
          end
        end
      end
    end
  end
end
