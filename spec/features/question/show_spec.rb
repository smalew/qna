# frozen_string_literal: true

require 'rails_helper'

feature 'User can see current question', "
  In order to see question from community
  As a authenticated user
  I'd like to ba able to see current question
" do
  given!(:question) { create(:question) }

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    background { sign_in(user) }

    scenario 'can see question' do
      visit question_path(question)

      expect(page).to have_content(question.title)
      expect(page).to have_content(question.body)
    end

    context 'can see link' do
      context 'if link is gist' do
        given!(:link) { create(:link, linkable: question, url: 'https://gist.github.com/user/ca9b0cab4a7847c') }

        background do
          answer = Struct.new(:answer) do
            def files
              content = Struct.new(:content)
              { 'some filename.txt' => content.new('Test content') }
            end
          end
          allow_any_instance_of(Octokit::Client).to receive(:gist).and_return(answer.new)
        end

        scenario 'its filename and content' do
          visit question_path(question)

          within '.attached-links' do
            expect(page).to have_content('some filename.txt')
            expect(page).to have_content('Test content')
          end
        end
      end

      context 'if link is not gist' do
        given!(:link) { create(:link, linkable: question, url: 'https://some.com/') }

        scenario 'its url adress' do
          visit question_path(question)

          within '.attached-links' do
            expect(page).to have_link(link.name)
          end
        end
      end
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
