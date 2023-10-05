# Create doctors
doctor_1 = Doctor.create!(
  name: "Dr. John Doe",
  work_start_time: Time.parse("9:00 AM UTC").to_formatted_s(:db),
  work_end_time: Time.parse("5:00 PM UTC").to_formatted_s(:db),
  slot_duration: 55,
  break_duration: 5
)

doctor_2 = Doctor.create!(
  name: "Dr. Jane Doe",
  work_start_time: Time.parse("11:00 AM UTC").to_formatted_s(:db),
  work_end_time: Time.parse("7:00 PM UTC").to_formatted_s(:db),
  slot_duration: 25,
  break_duration: 5
)

# Create appointments
Appointment.create!(
  doctor_id: doctor_1.id,
  start_time: DateTime.parse("04.10.2023 10:00 AM").to_formatted_s(:db),
  patient_name: "John Doe"
)
Appointment.create!(
  doctor_id: doctor_1.id,
  start_time: DateTime.parse("04.10.2023 11:00 AM").to_formatted_s(:db),
  patient_name: "John Doe"
)
Appointment.create!(
  doctor_id: doctor_2.id,
  start_time: DateTime.parse("04.10.2023 11:00 AM").to_formatted_s(:db),
  patient_name: "John Doe"
)
