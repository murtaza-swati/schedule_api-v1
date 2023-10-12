require "faker"

FactoryBot.define do
  factory :appointment do
    start_time { DateTime.parse("01.01.2023 10:00 AM UTC") }
    patient_name { Faker::Name.name }
    doctor
  end
end
