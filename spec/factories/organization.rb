FactoryBot.define do
  factory :organization do
    name { "Empire" }
    api_key { SecureRandom.hex(32) }
  end
end
