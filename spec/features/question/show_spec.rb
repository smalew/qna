require 'rails_helper'

feature 'User can see current question', %q{
  In order to see question from community
  As a authenticated user
  I'd like to ba able to see current question
} do
  given!(:question) { create(:question) }

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background { sign_in(user) }

    scenario 'can see question' do
      visit question_path(question)

      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body)
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can see question' do
      visit question_path(question)

      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body)
    end
  end
end
