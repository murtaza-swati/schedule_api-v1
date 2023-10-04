# == Schema Information
#
# Table name: doctors
#
#  id                        :integer          not null, primary key
#  name                      :string
#  work_start_time           :time
#  work_end_time             :time
#  slot_duration_in_minutes  :integer
#  appointment_slot_limit    :integer
#  break_duration_in_minutes :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
class Doctor < ActiveRecord::Base
  has_many :appointments

  # This method checks if the given appointment_time falls within the doctor's working hours.
  def appointment_within_working_hours?(appointment_time)
    appt_time_as_time = Time.new(
      work_start_time.year,
      work_start_time.month,
      work_start_time.day,
      appointment_time.hour,
      appointment_time.min,
      appointment_time.sec,
      appointment_time.zone
    )
    # Calculate appointment end time using the doctor's slot_duration_in_minutes
    appointment_end_time = appt_time_as_time + slot_duration_in_minutes.minutes

    # Check if both start and end times are within doctor's working hours.
    appt_time_as_time.between?(work_start_time, work_end_time) &&
    appointment_end_time.between?(work_start_time, work_end_time)
  end
end
