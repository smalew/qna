FactoryBot.define do
  factory :regard do
    question
    answer

    sequence(:title) { |n| "Regard title #{n}" }
    image { fixture_file_upload(Rails.root.join('spec', 'images', 'regard.jpg')) }
  end
end
