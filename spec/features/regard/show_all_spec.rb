require 'rails_helper'

feature 'User can see all regards', %q{
  In order to see regards from users
  As a authenticated user
  I'd like to ba able to see all questions
} do
  given!(:user) { create(:user) }
  given(:question1) { create(:question, user: user) }
  given!(:answer1) { create(:answer, user: user, best_answer: true) }
  given!(:regard1) { create(:regard, question: question1, answer: answer1) }

  given(:question2) { create(:question, user: user) }
  given!(:answer2) { create(:answer, user: user, best_answer: true) }
  given!(:regard2) { create(:regard, question: question2, answer: answer2) }

  given(:question3) { create(:question, user: user) }
  given!(:answer3) { create(:answer, best_answer: true) }
  given!(:regard3) { create(:regard, question: question3, answer: answer3) }

  given(:regards) { [regard1, regard2] }

  describe 'Authenticated user' do
    background { sign_in(user) }

    scenario 'can see regards' do
      visit regards_path

      regards.each do |regard|
        expect(page).to have_content(I18n.t('regard.header'))
        expect(page).to have_content(regard.question.title)
        expect(page).to have_content(regard.title)
        expect(page).to have_css("img[src*='#{regard.image.filename}']")
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can see questions' do
      visit regards_path

      expect(page).to have_content('You need to sign in or sign up before continuing.')
    end
  end
end
