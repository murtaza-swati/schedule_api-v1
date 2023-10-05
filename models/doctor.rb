# == Schema Information
#
# Table name: doctors
#
#  id                        :integer          not null, primary key
#  name                      :string
#  work_start_time           :time
#  work_end_time             :time
#  slot_duration             :integer
#  appointment_slot_limit    :integer
#  break_duration            :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
class Doctor < ActiveRecord::Base
  has_many :appointments

  validates :name, :work_start_time, :work_end_time, :slot_duration,
    :break_duration, presence: true

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
    # Calculate appointment end time using the doctor's slot_duration
    appointment_end_time = appt_time_as_time + slot_duration.minutes

    # Check if both start and end times are within doctor's working hours.
    appt_time_as_time.between?(work_start_time, work_end_time) &&
      appointment_end_time.between?(work_start_time, work_end_time)
  end
end
