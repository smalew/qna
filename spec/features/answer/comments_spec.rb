require 'rails_helper'

feature 'User can create comments for answer', %q{
  In order to ask something about answer
  As a authenticated user
  I'd like to ba able to create comment for answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user', js: true do
    background { sign_in(user) }
    background { visit question_path(question) }

    context 'can create comment' do
      scenario 'with correct params' do
        within '.answers' do
          within "#answer-id-#{answer.id}" do
            fill_in :comment_body, with: 'New Answer comment body'

            click_on I18n.t('comments.create')

            expect(page).to have_content('New Answer comment body')
          end
        end
      end
    end

    context 'can not create comment' do
      scenario 'with empty body' do
        within '.answers' do
          within "#answer-id-#{answer.id}" do
            fill_in :comment_body, with: ''

            click_on I18n.t('comments.create')

            within '.comment-errors' do
              expect(page).to have_content("Body can't be blank")
            end
          end
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    given!(:question) { create(:question) }

    background { visit question_path(question) }

    scenario 'can not create comment' do
      within "#question-#{question.id}" do
        expect(page).to_not have_link(I18n.t('comments.create'))
      end
    end
  end
end
