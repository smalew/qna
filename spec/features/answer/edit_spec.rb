# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit answer', "
  In order to change answer
  As a authenticated user
  I'd like to ba able to edit answer to the question
" do
  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }
    given!(:answer) { create(:answer, question: question, user: author) }
    given!(:another_answer) { create(:answer, question: question, user: author) }
    given(:url) { 'https://github.com/smalew/9d8eeda188e2cdc28ca9b0cab4a7847c' }

    background { sign_in(user) }
    background { visit question_path(question) }

    context 'when answer owner' do
      given(:author) { user }

      context 'can edit answer' do
        scenario 'with correct params' do
          within '.answers' do
            within "#answer-id-#{answer.id}" do
              click_on I18n.t('answer.form.edit_button')

              fill_in :new_answer_body, with: 'New Answer body'

              click_on I18n.t('answer.form.save_button')

              expect(page).to have_content('New Answer body')
              expect(page).to_not have_content(answer.body)
              within '.new-answer' do
                expect(page).to_not have_selector('textarea')
              end
            end

            within "#answer-id-#{another_answer.id}" do
              expect(page).to_not have_content('New Answer body')
              within '.new-answer' do
                expect(page).to_not have_selector('textarea')
              end
            end
          end
        end

        scenario 'with empty body' do
          within '.answers' do
            within "#answer-id-#{answer.id}" do
              click_on I18n.t('answer.form.edit_button')

              fill_in :new_answer_body, with: ''

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

              fill_in :new_answer_body, with: 'New Answer body'
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

              fill_in :new_answer_body, with: 'New Answer body'
              attach_file 'Files', [
                Rails.root.join('spec', 'rails_helper.rb'),
                Rails.root.join('spec', 'spec_helper.rb')
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

        scenario 'with one link' do
          within '.answers' do
            within "#answer-id-#{answer.id}" do
              click_on I18n.t('answer.form.edit_button')
              click_on 'Add Link'

              within '#new-links' do
                within first('.nested-fields') do
                  fill_in I18n.t('links.name'), with: 'Link name'
                  fill_in I18n.t('links.url'), with: url
                end
              end

              click_on I18n.t('answer.form.save_button')
            end
          end

          within '.answers' do
            within '.attached-links' do
              expect(page).to have_link('Link name', href: url)
            end
          end
        end

        scenario 'with several links' do
          within '.answers' do
            within "#answer-id-#{answer.id}" do
              click_on I18n.t('answer.form.edit_button')
              click_on 'Add Link'

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

              click_on I18n.t('answer.form.save_button')
            end
          end

          within '.attached-links' do
            expect(page).to have_link('Link name', href: url)
            expect(page).to have_link('Link name second', href: url)
          end
        end

        scenario 'with incorrect link' do
          within '.answers' do
            within "#answer-id-#{answer.id}" do
              click_on I18n.t('answer.form.edit_button')
              click_on 'Add Link'

              within '#new-links' do
                within first('.nested-fields') do
                  fill_in I18n.t('links.name'), with: 'Link name'
                  fill_in I18n.t('links.url'), with: 'Incorrect link'
                end
              end

              click_on I18n.t('answer.form.save_button')
            end
          end

          expect(page).to_not have_link('Link name', href: url)
          expect(page).to have_content('Links url is invalid')
        end
      end

      context 'can delete attachment' do
        given!(:answer) { create(:answer, :with_file, question: question, user: author) }
        given(:attachment) { answer.files.first }

        scenario 'attached file' do
          within '.answers' do
            within "#answer-id-#{answer.id}" do
              within '.attachments' do
                expect(page).to have_content(attachment.filename)

                click_on I18n.t('delete_attachment')

                expect(page).to_not have_content(attachment.filename)
              end
            end
          end
        end
      end

      context 'can delete current attachment from several' do
        given!(:answer) { create(:answer, :with_files, question: question, user: author) }
        given(:attachment1) { answer.files.first }
        given(:attachment2) { answer.files.last }

        scenario 'attached file' do
          within '.answers' do
            within "#answer-id-#{answer.id}" do
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
        given!(:answer) { create(:answer, :with_link, question: question, user: author) }
        given(:link) { answer.links.first }

        scenario 'attached link' do
          within '.answers' do
            within "#answer-id-#{answer.id}" do
              within '.attached-links' do
                expect(page).to have_content(link.name)

                click_on I18n.t('links.delete')

                expect(page).to_not have_content(link.name)
              end
            end
          end
        end
      end

      context 'can delete current link from several' do
        given!(:answer) { create(:answer, :with_links, question: question, user: author) }
        given(:link1) { answer.links.first }
        given(:link2) { answer.links.last }

        scenario 'attached link' do
          within '.answers' do
            within "#answer-id-#{answer.id}" do
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
      end
    end

    context "someone else's answer" do
      given!(:answer) { create(:answer, :with_file, :with_link, question: question, user: author) }
      given!(:another_answer) { create(:answer, :with_file, :with_link, question: question, user: author) }
      given(:author) { create(:user) }

      scenario 'edit answer to the question' do
        within '.answers' do
          expect(page).to_not have_link(I18n.t('answer.form.edit_button'))
        end
      end

      scenario 'delete attachment' do
        within '.answers' do
          within "#answer-id-#{answer.id}" do
            within '.attachments' do
              expect(page).to_not have_link(I18n.t('delete_attachment'))
            end
          end
        end
      end

      scenario 'delete link' do
        within '.answers' do
          within "#answer-id-#{answer.id}" do
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

    scenario 'edit answer' do
      within '.answers' do
        expect(page).to_not have_link(I18n.t('answer.form.edit_button'))
      end
    end
  end
end
