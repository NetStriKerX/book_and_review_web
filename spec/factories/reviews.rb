#frozen_string_literal: true

FactoryBot.define do
  factory :review do
    comment { Faker::Lorem.paragraph }
    star { Faker::Number.within(range: 0.0..10.0) }
  end
end
