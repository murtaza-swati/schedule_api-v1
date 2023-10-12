class Appointment::Presenter < SimpleDelegator
  def to_h
    {
      id: id,
      patient_name: patient_name,
      start_time: start_time,
      end_time: calc_end_time
    }
  end

  private

  def calc_end_time
    start_time + doctor.slot_duration.minutes
  end
end
