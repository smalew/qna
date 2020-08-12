require 'rails_helper'

feature 'User can see answer changes in realtime', %q{
  In order to get information immediately
  I'd like to ba able to get actual information
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:url) { 'https://github.com/smalew/9d8eeda188e2cdc28ca9b0cab4a7847c' }

  context "create", js: true do
    scenario "answer appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '#new-answer' do

          fill_in 'Body', with: 'Answer body'

          attach_file 'Files', [
            Rails.root.join('spec', 'rails_helper.rb'),
            Rails.root.join('spec', 'spec_helper.rb'),
          ]

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
          expect(page).to have_content('Answer body')
          expect(page).to have_link('rails_helper.rb')
          expect(page).to have_link('spec_helper.rb')
          expect(page).to have_link('Link name', href: url)
          expect(page).to have_link('Link name second', href: url)
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          expect(page).to have_content('Answer body')
          expect(page).to have_link('rails_helper.rb')
          expect(page).to have_link('spec_helper.rb')
          expect(page).to have_link('Link name', href: url)
          expect(page).to have_link('Link name second', href: url)
        end
      end
    end
  end

  context "create_comments", js: true do
    given!(:answer) { create(:answer, question: question) }

    scenario "answer appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.answers' do
          within "#answer-id-#{answer.id}" do
            fill_in :comment_body, with: 'New Answer comment body'

            click_on I18n.t('comments.create')

            expect(page).to have_content('New Answer comment body')
          end
        end
      end

      Capybara.using_session('guest') do
        within '.answers' do
          within "#answer-id-#{answer.id}" do
            expect(page).to have_content('New Answer comment body')
          end
        end
      end
    end
  end
end
