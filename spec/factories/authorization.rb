FactoryBot.define do
  factory :authorization do
    user

    provider { 'Some Provider' }
    uid { 'Some uid' }
  end
end
