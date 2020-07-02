FactoryBot.define do
  factory :answer do
    user
    question

    body { "My body" }

    trait :empty_body do
      body { '' }
    end
  end
end
