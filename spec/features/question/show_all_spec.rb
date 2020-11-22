# frozen_string_literal: true

require 'rails_helper'

feature 'User can see all questions', "
  In order to see questions from community
  As a authenticated user
  I'd like to ba able to see all questions
" do
  given!(:questions) { create_list(:question, 5) }

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background { sign_in(user) }

    scenario 'can see questions' do
      visit questions_path

      expect(page).to have_content(I18n.t('question.header'))
      questions.each do |question|
        expect(page).to have_content(question.title)
        expect(page).to have_content(question.body)
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can see questions' do
      visit questions_path
      expect(page).to have_content(I18n.t('question.header'))
      questions.each do |question|
        expect(page).to have_content(question.title)
        expect(page).to have_content(question.body)
      end
    end
  end
end
