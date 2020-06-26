FactoryBot.define do
  factory :answer do
    body { "My body" }

    trait :empty_body do
      body { '' }
    end
  end
end
