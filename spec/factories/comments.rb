FactoryBot.define do
  factory :comment do
    user
    association :commentable, factory: :question

    body { 'Some comment body' }

    trait :empty_body do
      body { '' }
    end
  end
end
