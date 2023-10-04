class Appointment::OverlappingScope
  def self.call(appointment)
    new(
      appointment_id: appointment.id,
      doctor_id: appointment.doctor_id,
      start_time: appointment.start_time,
      slot_duration: appointment.doctor.slot_duration_in_minutes,
      break_duration: appointment.doctor.break_duration_in_minutes
    ).call
  end

  def initialize(appointment_id: nil, doctor_id: nil, start_time: nil, slot_duration: nil, break_duration: nil)
    self.id = appointment_id
    self.doctor_id = doctor_id
    self.start_time = start_time
    self.slot_duration = slot_duration
    self.break_duration = break_duration
  end

  def call
    module_parent
      .where(doctor_id: doctor_id)
      .where(sql)
      .where.not(id: id)
  end

  delegate :module_parent, to: :class

  private

  attr_accessor :id, :doctor_id, :start_time, :slot_duration, :break_duration, :options

  def sql
    format(
      <<-SQL,
        (start_time <= '%{slot_end_time}' AND datetime(start_time, '+%{slot_duration} minutes') > '%{start_time}') OR
        ('%{start_time}' < datetime('%{slot_end_time}', '+%{break_duration} minutes') AND '%{start_time}' >= '%{slot_end_time}')
      SQL
      slot_end_time: slot_end_time.strftime('%Y-%m-%d %H:%M:%S'),
      start_time: start_time.strftime('%Y-%m-%d %H:%M:%S'),
      slot_duration: slot_duration,
      break_duration: break_duration
    )
  end

  def slot_end_time
    @slot_end_time ||= (start_time + slot_duration.minutes)
  end
end
