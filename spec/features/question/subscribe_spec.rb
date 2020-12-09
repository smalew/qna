# frozen_string_literal: true

require 'rails_helper'

feature 'User can subscribe to question', "
  In order to knew about question activity
  As a authenticated user
  I'd like to ba able to subscribe for notify
" do
  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background { sign_in(user) }

    context 'question owner', js: true do
      context 'already subscribed' do
        given(:question) { create(:question, :with_regard, user: user) }

        scenario 'cannot subscribe again' do
          visit question_path(question)

          within '#subscription' do
            expect(page).to_not have_content('Subscribe')
            expect(page).to have_content('Unsubscribe')
          end
        end

        scenario 'can unsubscribe' do
          visit question_path(question)

          within '#subscription' do
            click_on 'Unsubscribe'

            expect(page).to_not have_content('Unsubscribe')
            expect(page).to have_content('Subscribe')
          end
        end
      end

      context 'not subscribed' do
        given(:question) { create(:question, :with_regard, user: user) }

        scenario 'cannot unsubscribe again' do
          visit question_path(question)

          within '#subscription' do
            click_on 'Unsubscribe'

            expect(page).to have_content('Subscribe')
            expect(page).to_not have_content('Unsubscribe')
          end
        end

        scenario 'can subscribe' do
          visit question_path(question)

          within '#subscription' do
            click_on 'Unsubscribe'

            expect(page).to_not have_content('Unsubscribe')
            expect(page).to have_content('Subscribe')

            click_on 'Subscribe'

            expect(page).to_not have_content('Subscribe')
            expect(page).to have_content('Unsubscribe')
          end
        end
      end
    end

    context 'is not question owner', js: true do
      given(:another_user) { create(:user) }
      context 'subscribing' do
        given(:question) { create(:question, :with_regard, user: another_user) }

        scenario 'can subscribe' do
          visit question_path(question)

          within '#subscription' do
            click_on 'Subscribe'

            expect(page).to_not have_content('Subscribe')
            expect(page).to have_content('Unsubscribe')
          end
        end

        scenario 'can unsubscribe' do
          visit question_path(question)

          within '#subscription' do
            click_on 'Subscribe'

            expect(page).to_not have_content('Subscribe')
            expect(page).to have_content('Unsubscribe')

            click_on 'Unsubscribe'

            expect(page).to_not have_content('Unsubscribe')
            expect(page).to have_content('Subscribe')
          end
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    given(:question) { create(:question) }

    scenario 'choose best answer' do
      visit question_path(question)

      expect(page).to_not have_css('#subscription')
    end
  end
end
