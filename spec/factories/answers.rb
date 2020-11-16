# == Schema Information
#
# Table name: answers
#
#  id          :bigint           not null, primary key
#  question_id :bigint
#  body        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint
#  best_answer :boolean          default(FALSE)
#
FactoryBot.define do
  factory :answer do
    user
    question

    body { "My body" }
    best_answer { false }

    trait :empty_body do
      body { '' }
    end

    trait :with_file do
      before :create do |answer|
        answer.files.attach fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'))
      end
    end

    trait :with_files do
      before :create do |question|
        question.files.attach fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'))
        question.files.attach fixture_file_upload(Rails.root.join('spec', 'spec_helper.rb'))
      end
    end

    trait :with_link do
      before :create do |answer|
        create(:link, linkable: answer)
      end
    end

    trait :with_links do
      before :create do |question|
        create_list(:link, 2,  linkable: question)
      end
    end
  end
end
