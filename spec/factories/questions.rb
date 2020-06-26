FactoryBot.define do
  factory :question do
    title { "My title" }
    body { "My body" }

    trait :empty_title do
      title { '' }
    end

    trait :empty_body do
      body { '' }
    end
  end
end
