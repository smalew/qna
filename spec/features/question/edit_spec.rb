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

    context 'when question owner' do
      given(:author) { user }

      context 'can be edited' do
        background { click_on I18n.t('question.edit_button') }

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
        background { click_on I18n.t('question.edit_button') }

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

      context 'can delete attachment' do
        given!(:question) { create(:question, :with_file, user: user) }

        scenario 'attached file' do
          within '#question' do
            within '.attachments' do
              expect(page).to have_content(question.files.first.filename)

              click_on I18n.t('delete_attachment')

              expect(page).to_not have_content(question.files.first.filename)
            end
          end
        end
      end

      context 'can delete current attachment from several' do
        given!(:question) { create(:question, :with_files, user: user) }
        given(:attachment1) { question.files.first }
        given(:attachment2) { question.files.last }

        scenario 'attached file' do
          within '#question' do
            within '.attachments' do
              expect(page).to have_content(attachment1.filename)
              expect(page).to have_content(attachment2.filename)

              within "#attachment-id-#{attachment1.id}" do
                click_on I18n.t('delete_attachment')
              end

              expect(page).to_not have_content(attachment1.filename)
              expect(page).to have_content(attachment2.filename)
            end
          end
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

      context 'can not be deleted any' do
        given!(:question) { create(:question, :with_file, user: author) }

        scenario 'attached file' do
          within '#question' do
            within '.attachments' do
              expect(page).to_not have_link(I18n.t('delete_attachment'))
            end
          end
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
