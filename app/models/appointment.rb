# == Schema Information
#
# Table name: appointments
#
#  id           :integer          not null, primary key
#  doctor_id    :integer
#  patient_name :string
#  start_time   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# models/appointment.rb

class Appointment < ActiveRecord::Base
  belongs_to :doctor

  scope :overlapping, OverlappingScope
  validates :patient_name, :start_time, presence: true
  validate :start_time_within_working_hours
  validate :no_double_booking

  private

  def start_time_within_working_hours
    unless start_time && doctor&.appointment_within_working_hours?(start_time)
      errors.add(:start_time, "must be within the doctor's working hours")
    end
  end

  def no_double_booking
    overlapping_appointments = self.class.overlapping(self)

    if overlapping_appointments.exists?
      errors.add(:start_time, "has overlapping appointments")
    end
  end
end
