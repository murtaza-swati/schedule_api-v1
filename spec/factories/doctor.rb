require "faker"

FactoryBot.define do
  factory :doctor do
    name { Faker::Name.name }
    work_start_time { Time.parse("9:00 AM UTC") }
    work_end_time { Time.parse("5:00 PM UTC") }
    slot_duration { 55 }
    break_duration { 5 }
  end
end
