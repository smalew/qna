FactoryBot.define do
  factory :rate do
    user
    association :ratable, factory: :question

    positive { false }
    negative { false }
  end
end
