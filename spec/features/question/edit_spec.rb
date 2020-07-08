require 'rails_helper'

feature 'User can edit question', %q{
  In order to change the question
  As a authenticated user
  I'd like to ba able to edit the question
} do
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }
    given!(:question) { create(:question, user: author) }

    background { sign_in(user) }
    background { visit question_path(question) }

    context 'own answer' do
      given(:author) { user }

      background { click_on I18n.t('question.edit_button') }

      context 'can be edited' do

        scenario 'with correct params' do
          within '#question' do
            fill_in 'Title', with: 'New Question title'
            fill_in 'Body', with: 'New Question body'

            click_on I18n.t('question.save_button')

            expect(page).to have_content('New Question title')
            expect(page).to have_content('New Question body')
            expect(page).to_not have_content(question.title)
            expect(page).to_not have_content(question.body)
            expect(page).to_not have_selector('textarea')
          end
        end

        scenario 'with attached file' do
          within '#question' do
            fill_in 'Title', with: 'New Question title'
            fill_in 'Body', with: 'New Question body'
            attach_file 'Files', Rails.root.join('spec', 'rails_helper.rb')

            click_on I18n.t('question.save_button')

            expect(page).to have_link('rails_helper.rb')
          end
        end

        scenario 'with several attached file' do
          within '#question' do
            fill_in 'Title', with: 'New Question title'
            fill_in 'Body', with: 'New Question body'
            attach_file 'Files', [
              Rails.root.join('spec', 'rails_helper.rb'),
              Rails.root.join('spec', 'spec_helper.rb')
            ]

            click_on I18n.t('question.save_button')

            expect(page).to have_link('rails_helper.rb')
            expect(page).to have_link('spec_helper.rb')
          end
        end
      end

      context 'can not be edited' do
        scenario 'with empty title' do
          within '#question' do
            fill_in 'Title', with: ''
            fill_in 'Body', with: 'New Question body'

            click_on I18n.t('question.save_button')

            expect(page).to have_content(question.title)
            expect(page).to have_content(question.body)
          end

          within '.question-errors' do
            expect(page).to have_content("Title can't be blank")
          end
        end

        scenario 'with empty body' do
          within '#question' do
            fill_in 'Title', with: 'New Question title'
            fill_in 'Body', with: ''

            click_on I18n.t('question.save_button')

            expect(page).to have_content(question.title)
            expect(page).to have_content(question.body)
          end

          within '.question-errors' do
            expect(page).to have_content("Body can't be blank")
          end
        end
      end
    end

    context 'can delete' do
      given!(:question) { create(:question, :with_file, user: user) }

      scenario 'attached file' do
        within '#question' do
          expect(page).to have_content(question.files.first.filename)

          click_on 'Delete attachment'

          expect(page).to_not have_content(question.files.first.filename)
        end
      end
    end

    context "someone else's question" do
      given(:author) { create(:user) }

      scenario 'can not be edited' do
        within '#question' do
          expect(page).to_not have_link(I18n.t('question.edit_button'))
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    background { visit question_path(question) }

    scenario 'can not be edited' do
      within '#question' do
        expect(page).to_not have_link(I18n.t('question.edit_button'))
      end
    end
  end
end
