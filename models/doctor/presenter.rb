require "delegate"

class Doctor::Presenter < SimpleDelegator
  def availability
    {
      doctor_id: id,
      working_hours: {
        start_time: work_start_time.to_formatted_s(:time),
        end_time: work_end_time.to_formatted_s(:time)
      }
    }
  end
end
