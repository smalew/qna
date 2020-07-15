FactoryBot.define do
  factory :link do
    association :linkable, factory: :question
    sequence(:name) { |n| "Link name#{n}" }
    url { 'https://github.com/smalew/9d8eeda188e2cdc28ca9b0cab4a7847c' }
  end
end
