FactoryBot.define do
  factory :answer do
    user
    question

    body { "My body" }
    best_answer { false }

    trait :empty_body do
      body { '' }
    end
  end
end
