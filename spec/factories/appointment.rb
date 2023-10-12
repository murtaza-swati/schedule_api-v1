require "faker"

FactoryBot.define do
  factory :appointment do
    start_time { Time.now }
    patient_name { Faker::Name.name }
    doctor
  end
end
