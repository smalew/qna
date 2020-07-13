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
    end
  end

  describe 'Unauthenticated user' do
    background { visit questions_path }

    scenario 'ask question' do
      click_on I18n.t('question.new_button')

      expect(page).to have_content(I18n.t('devise.failure.unauthenticated'))
    end
  end
end
