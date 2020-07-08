require 'rails_helper'

feature 'User can edit answer', %q{
  In order to change answer
  As a authenticated user
  I'd like to ba able to edit answer to the question
} do
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }
    given!(:answer) { create(:answer, question: question, user: author) }
    given!(:another_answer) { create(:answer, question: question, user: author) }

    background { sign_in(user) }
    background { visit question_path(question) }

    context 'own answer' do
      given(:author) { user }

      context 'edit answer' do
        scenario 'with correct params' do
          within '.answers' do
            within "#answer-id-#{answer.id}" do
              click_on I18n.t('answer.form.edit_button')

              fill_in 'Body', with: 'New Answer body'

              click_on I18n.t('answer.form.save_button')

              expect(page).to have_content('New Answer body')
              expect(page).to_not have_content(answer.body)
              expect(page).to_not have_selector('textarea')
            end

            within "#answer-id-#{another_answer.id}" do
              expect(page).to_not have_content('New Answer body')
              expect(page).to_not have_selector('textarea')
            end
          end
        end

        scenario 'with empty body' do
          within '.answers' do
            within "#answer-id-#{answer.id}" do
              click_on I18n.t('answer.form.edit_button')

              fill_in 'Body', with: ''

              click_on I18n.t('answer.form.save_button')

              expect(page).to have_content(answer.body)
              expect(page).to have_selector('textarea')
            end
          end

          within '.answer-errors' do
            expect(page).to have_content("Body can't be blank")
          end
        end

        scenario 'with attached file' do
          within '.answers' do
            within "#answer-id-#{answer.id}" do
              click_on I18n.t('answer.form.edit_button')

              fill_in 'Body', with: 'New Answer body'
              attach_file 'Files', Rails.root.join('spec', 'rails_helper.rb')

              click_on I18n.t('answer.form.save_button')

              expect(page).to have_link('rails_helper.rb')
            end

            within "#answer-id-#{another_answer.id}" do
              expect(page).to_not have_link('rails_helper.rb')
            end
          end
        end

        scenario 'with several attached file' do
          within '.answers' do
            within "#answer-id-#{answer.id}" do
              click_on I18n.t('answer.form.edit_button')

              fill_in 'Body', with: 'New Answer body'
              attach_file 'Files', [
                Rails.root.join('spec', 'rails_helper.rb'),
                Rails.root.join('spec', 'spec_helper.rb'),
              ]

              click_on I18n.t('answer.form.save_button')

              expect(page).to have_link('rails_helper.rb')
              expect(page).to have_link('spec_helper.rb')
            end

            within "#answer-id-#{another_answer.id}" do
              expect(page).to_not have_link('rails_helper.rb')
              expect(page).to_not have_link('spec_helper.rb')
            end
          end
        end
      end
    end

    context "someone else's answer" do
      given(:author) { create(:user) }

      scenario 'edit answer to the question' do
        within '.answers' do
          expect(page).to_not have_link(I18n.t('answer.form.edit_button'))
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    background { visit question_path(question) }

    scenario 'edit answer' do
      within '.answers' do
        expect(page).to_not have_link(I18n.t('answer.form.edit_button'))
      end
    end
  end
end
