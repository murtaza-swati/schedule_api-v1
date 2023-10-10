FactoryBot.define do
  factory :organization do
    name { "Empire" }
    sequence(:email) { |n| "email_#{n}@example.com" }
    api_key { SecureRandom.hex(32) }
  end
end
