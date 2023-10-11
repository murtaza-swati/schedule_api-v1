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

  # Validates the presence of name, work_start_time, work_end_time, slot_duration, and break_duration.
  validates :name, :work_start_time, :work_end_time, :slot_duration,
    :break_duration, presence: true

  # Validates that work_start_time is before work_end_time.
  validate :work_start_time_before_work_end_time

  # Validates that slot_duration is shorter than the doctor's working hours.
  validate :slot_duration_is_shorter_than_working_hours

  # Checks if the appointment time is within the doctor's working hours.
  #
  # @param appointment_time [Time] the time of the appointment
  # @return [Boolean] true if the appointment is within working hours, false otherwise
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

  private

  # Validates that work_start_time is before work_end_time.
  def work_start_time_before_work_end_time
    return unless work_start_time && work_end_time

    if work_start_time >= work_end_time
      errors.add(:work_start_time, "must be before work end time")
    end
  end

  # Validates that slot_duration is shorter than the doctor's working hours.
  def slot_duration_is_shorter_than_working_hours
    return unless work_start_time && work_end_time && slot_duration

    work_duration = (work_end_time - work_start_time) / 60

    if slot_duration >= work_duration
      errors.add(:slot_duration, "must be shorter than working hours")
    end
  end
end
