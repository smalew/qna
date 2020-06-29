FactoryBot.define do
  sequence :email do |n|
    "user_#{n}@mail.com"
  end

  factory :user do
    email

    password { '123456789' }
    password_confirmation { '123456789' }

    trait :empty_password do
      password { '' }
      password_confirmation { '' }
    end
  end
end
