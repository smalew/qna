# frozen_string_literal: true

require 'rails_helper'

feature 'User can see all answers for question', "
  In order to see answers for question
  As a authenticated user
  I'd like to ba able to see all answers
" do
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 2, question: question) }

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background { sign_in(user) }

    scenario 'see question' do
      visit question_path(question)

      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body)

      within '.answers' do
        answers.each do |answer|
          expect(page).to have_content(answer.body)
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'see question' do
      visit question_path(question)

      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body)

      within '.answers' do
        answers.each do |answer|
          expect(page).to have_content(answer.body)
        end
      end
    end
  end
end
