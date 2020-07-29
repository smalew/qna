include ActionDispatch::TestProcess

FactoryBot.define do
  factory :question do
    user

    sequence(:title) { |n| "Question title #{n}" }
    sequence(:body) { |n| "Question body #{n}" }

    trait :empty_title do
      title { '' }
    end

    trait :empty_body do
      body { '' }
    end

    trait :with_file do
      before :create do |question|
        question.files.attach fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'))
      end
    end

    trait :with_files do
      before :create do |question|
        question.files.attach fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'))
        question.files.attach fixture_file_upload(Rails.root.join('spec', 'spec_helper.rb'))
      end
    end

    trait :with_link do
      before :create do |question|
        create(:link, linkable: question)
      end
    end

    trait :with_links do
      before :create do |question|
        create_list(:link, 2,  linkable: question)
      end
    end

    trait :with_regard do
      before :create do |question|
        create(:regard,
               question: question,
               title: 'Regard title',
               image: fixture_file_upload(Rails.root.join('spec', 'images', 'regard.jpg')))
      end
    end
  end
end
