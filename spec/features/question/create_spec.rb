require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from community
  As a authenticated user
  I'd like to ba able to ask the question
} do
  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background { sign_in(user) }
    background { visit questions_path }
    background { click_on I18n.t('question.new_button') }

    context 'ask question' do

      scenario 'with correct params' do
        fill_in 'Title', with: 'Title question'
        fill_in 'Body', with: 'Body question'
        click_on I18n.t('question.form.create_button')

        expect(page).to have_content(I18n.t('question.successful_create'))
        expect(page).to have_content('Title question')
        expect(page).to have_content('Body question')
      end

      scenario 'ask question with empty title' do
        fill_in 'Title', with: ''
        fill_in 'Body', with: 'Body question'
        click_on I18n.t('question.form.create_button')

        expect(page).to have_content("Title can't be blank")
      end

      scenario 'ask question with empty body' do
        fill_in 'Title', with: 'Title question'
        fill_in 'Body', with: ''
        click_on I18n.t('question.form.create_button')

        expect(page).to have_content("Body can't be blank")
      end

      scenario 'with attached file' do
        fill_in 'Title', with: 'Title question'
        fill_in 'Body', with: 'Body question'
        attach_file 'Files', Rails.root.join('spec', 'rails_helper.rb')

        click_on I18n.t('question.form.create_button')

        expect(page).to have_link('rails_helper.rb')
      end

      scenario 'with several attached file' do
        fill_in 'Title', with: 'Title question'
        fill_in 'Body', with: 'Body question'
        attach_file 'Files', [
          Rails.root.join('spec', 'rails_helper.rb'),
          Rails.root.join('spec', 'spec_helper.rb'),
        ]

        click_on I18n.t('question.form.create_button')

        expect(page).to have_link('rails_helper.rb')
        expect(page).to have_link('spec_helper.rb')
      end

      context 'links', js: true do
        given(:url) { 'https://github.com/smalew/9d8eeda188e2cdc28ca9b0cab4a7847c' }

        scenario 'with one link' do
          fill_in 'Title', with: 'Title question'
          fill_in 'Body', with: 'Body question'

          within '#new-links' do
            within first('.nested-fields') do
              fill_in I18n.t('links.name'), with: 'Link name'
              fill_in I18n.t('links.url'), with: url
            end
          end

          click_on I18n.t('question.form.create_button')

          within '.attached-links' do
            expect(page).to have_link('Link name', href: url)
          end
        end

        scenario 'with several link' do
          fill_in 'Title', with: 'Title question'
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

          click_on I18n.t('question.form.create_button')

          within '.attached-links' do
            expect(page).to have_link('Link name', href: url)
            expect(page).to have_link('Link name second', href: url)
          end
        end

        scenario 'with incorrect link' do
          fill_in 'Title', with: 'Title question'
          fill_in 'Body', with: 'Body question'

          within '#new-links' do
            within first('.nested-fields') do
              fill_in I18n.t('links.name'), with: 'Link name'
              fill_in I18n.t('links.url'), with: 'Incorrect Link'
            end
          end

          click_on I18n.t('question.form.create_button')

          expect(page).to_not have_link('Link name', href: 'incorrect link')
          expect(page).to have_content("Links url is invalid")
        end
      end

      context 'best answer regard' do
        scenario 'with correct regard' do
          fill_in 'Title', with: 'Title question'
          fill_in 'Body', with: 'Body question'

          within '#best-answer-regard' do
            fill_in :question_regard_attributes_title, with: 'Regard title'
            attach_file 'Image', Rails.root.join('spec', 'images', 'regard.jpg')
          end

          click_on I18n.t('question.form.create_button')

          expect(page).to have_content(I18n.t('question.successful_create'))
          expect(page).to have_content('Title question')
          expect(page).to have_content('Body question')
        end

        scenario 'with empty title regard' do
          fill_in 'Title', with: 'Title question'
          fill_in 'Body', with: 'Body question'

          within '#best-answer-regard' do
            fill_in :question_regard_attributes_title, with: ''
            attach_file 'Image', Rails.root.join('spec', 'images', 'regard.jpg')
          end

          click_on I18n.t('question.form.create_button')

          expect(page).to have_content("Regard is invalid")
        end

        scenario 'with empty image regard' do
          fill_in 'Title', with: 'Title question'
          fill_in 'Body', with: 'Body question'

          within '#best-answer-regard' do
            fill_in :question_regard_attributes_title, with: 'Regard title'
          end

          click_on I18n.t('question.form.create_button')

          expect(page).to have_content("Regard is invalid")
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    background { visit questions_path }

    scenario 'ask question' do
      expect(page).to_not have_content(I18n.t('question.new_button'))
    end
  end
end
