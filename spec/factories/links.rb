# == Schema Information
#
# Table name: links
#
#  id            :bigint           not null, primary key
#  name          :string
#  url           :string
#  linkable_type :string
#  linkable_id   :bigint
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
FactoryBot.define do
  factory :link do
    association :linkable, factory: :question
    sequence(:name) { |n| "Link name#{n}" }
    url { 'https://github.com/smalew/9d8eeda188e2cdc28ca9b0cab4a7847c' }
  end
end
