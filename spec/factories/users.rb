FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }

    password { '123456789' }
    password_confirmation { '123456789' }

    trait :empty_password do
      password { '' }
      password_confirmation { '' }
    end
  end
end
