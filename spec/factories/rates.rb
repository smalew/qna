FactoryBot.define do
  factory :rate do
    user
    association :ratable, factory: :question

    status { -1 }
  end
end
