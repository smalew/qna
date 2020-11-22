# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit question', "
  In order to change the question
  As a authenticated user
  I'd like to ba able to edit the question
" do
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
          within "#question-#{question.id}" do
            fill_in :question_title, with: 'New Question title'
            fill_in :question_body, with: 'New Question body'

            click_on I18n.t('question.save_button')

            expect(page).to have_content('New Question title')
            expect(page).to have_content('New Question body')
            expect(page).to_not have_content(question.title)
            expect(page).to_not have_content(question.body)
            within '.edit-question' do
              expect(page).to_not have_selector('textarea')
            end
          end
        end

        scenario 'with attached file' do
          within "#question-#{question.id}" do
            fill_in :question_title, with: 'New Question title'
            fill_in :question_body, with: 'New Question body'
            attach_file :question_files, Rails.root.join('spec', 'rails_helper.rb')

            click_on I18n.t('question.save_button')

            expect(page).to have_link('rails_helper.rb')
          end
        end

        scenario 'with several attached file' do
          within "#question-#{question.id}" do
            fill_in :question_title, with: 'New Question title'
            fill_in :question_body, with: 'New Question body'
            attach_file :question_files, [
              Rails.root.join('spec', 'rails_helper.rb'),
              Rails.root.join('spec', 'spec_helper.rb')
            ]

            click_on I18n.t('question.save_button')

            expect(page).to have_link('rails_helper.rb')
            expect(page).to have_link('spec_helper.rb')
          end
        end

        context 'links', js: true do
          given(:url) { 'https://github.com/smalew/9d8eeda188e2cdc28ca9b0cab4a7847c' }

          scenario 'with one link' do
            within "#question-#{question.id}" do
              within '#new-links' do
                within first('.nested-fields') do
                  fill_in I18n.t('links.name'), with: 'Link name'
                  fill_in I18n.t('links.url'), with: url
                end
              end
            end

            click_on I18n.t('question.save_button')

            within "#question-#{question.id}" do
              within '.attached-links' do
                expect(page).to have_link('Link name', href: url)
              end
            end
          end

          scenario 'with several link' do
            within "#question-#{question.id}" do
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
            end

            click_on I18n.t('question.save_button')

            within "#question-#{question.id}" do
              within '.attached-links' do
                expect(page).to have_link('Link name', href: url)
                expect(page).to have_link('Link name second', href: url)
              end
            end
          end

          scenario 'with incorrect link' do
            within "#question-#{question.id}" do
              within '#new-links' do
                within first('.nested-fields') do
                  fill_in I18n.t('links.name'), with: 'Link name'
                  fill_in I18n.t('links.url'), with: 'Incorrect Link'
                end
              end
            end

            click_on I18n.t('question.save_button')

            expect(page).to_not have_link('Link name', href: 'incorrect link')
            expect(page).to have_content('Links url is invalid')
          end
        end
      end

      context 'can not be edited' do
        background { click_on I18n.t('question.edit_button') }

        scenario 'with empty title' do
          within "#question-#{question.id}" do
            fill_in :question_title, with: ''
            fill_in :question_body, with: 'New Question body'

            click_on I18n.t('question.save_button')

            expect(page).to have_content(question.title)
            expect(page).to have_content(question.body)
          end

          within '.question-errors' do
            expect(page).to have_content("Title can't be blank")
          end
        end

        scenario 'with empty body' do
          within "#question-#{question.id}" do
            fill_in :question_title, with: 'New Question title'
            fill_in :question_body, with: ''

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
          within "#question-#{question.id}" do
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
          within "#question-#{question.id}" do
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

    context 'can delete link' do
      given!(:question) { create(:question, :with_link, user: user) }
      given(:link_name) { question.links.first.name }

      scenario 'attached link' do
        within "#question-#{question.id}" do
          within '.attached-links' do
            expect(page).to have_content(link_name)

            click_on I18n.t('links.delete')

            expect(page).to_not have_content(link_name)
          end
        end
      end
    end

    context 'can delete current link from several' do
      given!(:question) { create(:question, :with_links, user: user) }
      given(:link1) { question.links.first }
      given(:link2) { question.links.last }

      scenario 'attached file', js: true do
        within "#question-#{question.id}" do
          within '.attached-links' do
            expect(page).to have_content(link1.name)
            expect(page).to have_content(link2.name)

            within "#link-id-#{link1.id}" do
              click_on I18n.t('links.delete')
            end

            expect(page).to_not have_content(link1.name)
            expect(page).to have_content(link2.name)
          end
        end
      end
    end

    context "someone else's question" do
      given(:author) { create(:user) }

      scenario 'can not be edited' do
        within "#question-#{question.id}" do
          expect(page).to_not have_link(I18n.t('question.edit_button'))
        end
      end

      context 'can not be deleted any' do
        given!(:question) { create(:question, :with_file, :with_link, user: author) }

        scenario 'attached file' do
          within "#question-#{question.id}" do
            within '.attachments' do
              expect(page).to_not have_link(I18n.t('delete_attachment'))
            end
          end
        end

        scenario 'link' do
          within "#question-#{question.id}" do
            within '.attached-links' do
              expect(page).to_not have_link(I18n.t('links.delete'))
            end
          end
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    background { visit question_path(question) }

    scenario 'can not be edited' do
      within "#question-#{question.id}" do
        expect(page).to_not have_link(I18n.t('question.edit_button'))
      end
    end
  end
end
