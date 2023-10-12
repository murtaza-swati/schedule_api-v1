class Appointment::Presenter < SimpleDelegator
  def formatted_start_time
    start_time.strftime("%d-%m-%Y %H:%M")
  end

  def formatted_end_time
    calc_end_time.strftime("%d-%m-%Y %H:%M")
  end

  def to_h
    {
      id: id,
      patient_name: patient_name,
      start_time: formatted_start_time,
      end_time: formatted_end_time
    }
  end

  private

  def calc_end_time
    start_time + doctor.slot_duration.minutes
  end
end
