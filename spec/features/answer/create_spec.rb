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
      within '#new-answer' do
        fill_in 'Body', with: 'Answer body'

        click_on I18n.t('answer.form.create_button')
      end

      within '.answers' do
        expect(page).to have_content('Answer body')
      end
    end

    scenario 'answer with empty body to the question' do
      within '#new-answer' do
        fill_in 'Body', with: ''

        click_on I18n.t('answer.form.create_button')
      end

      within '.answer-errors' do
        expect(page).to have_content("Body can't be blank")
      end
    end

    scenario 'answer with attached file' do
      within '#new-answer' do
        fill_in 'Body', with: 'Answer body'
        attach_file 'Files', Rails.root.join('spec', 'rails_helper.rb')

        click_on I18n.t('answer.form.create_button')
      end

      within '.answers' do
        expect(page).to have_content('Answer body')
        expect(page).to have_link('rails_helper.rb')
      end
    end

    scenario 'answer with several attached file' do
      within '#new-answer' do
        fill_in 'Body', with: 'Answer body'
        attach_file 'Files', [
          Rails.root.join('spec', 'rails_helper.rb'),
          Rails.root.join('spec', 'spec_helper.rb'),
        ]

        click_on I18n.t('answer.form.create_button')
      end

      within '.answers' do
        expect(page).to have_content('Answer body')
        expect(page).to have_link('rails_helper.rb')
        expect(page).to have_link('spec_helper.rb')
      end
    end

    context 'links', js: true do
      given(:url) { 'https://github.com/smalew/9d8eeda188e2cdc28ca9b0cab4a7847c' }

      scenario 'with one link' do
        within '#new-answer' do
          fill_in 'Body', with: 'Body question'

          within '#new-links' do
            within first('.nested-fields') do
              fill_in I18n.t('links.name'), with: 'Link name'
              fill_in I18n.t('links.url'), with: url
            end
          end

          click_on I18n.t('answer.form.create_button')
        end

        within '.answers' do
          within '.attached-links' do
            expect(page).to have_link('Link name', href: url)
          end
        end
      end

      scenario 'with several links' do
        within '#new-answer' do
          fill_in 'Body', with: 'Body question'

          within '#new-links' do
            within first('.nested-fields') do
              fill_in I18n.t('links.name'), with: 'Link name'
              fill_in I18n.t('links.url'), with: url
            end

            click_on 'Add Link'

            within all('.nested-fields')[1] do
              fill_in I18n.t('links.name'), with: 'Link name second'
              fill_in I18n.t('links.url'), with: url
            end
          end

          click_on I18n.t('answer.form.create_button')
        end

        within '.answers' do
          within '.attached-links' do
            expect(page).to have_link('Link name', href: url)
            expect(page).to have_link('Link name second', href: url)
          end
        end
      end

      scenario 'with incorrect link' do
        within '#new-answer' do
          fill_in 'Body', with: 'Body question'

          within '#new-links' do
            within first('.nested-fields') do
              fill_in I18n.t('links.name'), with: 'Link name'
              fill_in I18n.t('links.url'), with: 'Incorrect link'
            end
          end

          click_on I18n.t('answer.form.create_button')
        end

        expect(page).to_not have_link('Link name', href: url)
        expect(page).to have_content("Links url is invalid")
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
