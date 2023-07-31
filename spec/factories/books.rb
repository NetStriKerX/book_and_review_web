#frozen_string_literal: true

FactoryBot.define do
  factory :book do
    name { Faker::Book.title }
    description { Faker::Book.genre }
    release { DateTime.now }
    user {create(:user)}
  end
end
