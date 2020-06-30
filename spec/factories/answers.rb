FactoryBot.define do
  factory :answer do
    association :user
    association :question

    body { "My body" }

    trait :empty_body do
      body { '' }
    end
  end
end
