FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "Question title #{n}" }
    sequence(:body) { |n| "Question body #{n}" }

    trait :empty_title do
      title { '' }
    end

    trait :empty_body do
      body { '' }
    end
  end
end
