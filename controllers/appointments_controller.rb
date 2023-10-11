class AppointmentsController
  def self.call(action, params)
    params = AppointmentParams.call(params)
    if params.errors.any?
      {error: params.errors.to_h}
    else
      doctor = Doctor.find_by(id: params[:doctor_id])
      return {error: "Doctor not found"} unless doctor
      new(doctor, params.to_h).public_send(action)
    end
  end

  def initialize(doctor, params)
    self.doctor = doctor
    self.params = params
  end

  def index
    AvailableSlotService.call(
      doctor,
      start_date: parse_date(params[:start_date]),
      end_date: parse_date(params[:end_date])
    )
  end

  def create
    CreateAppointmentService.call(doctor, params)
  end

  private

  attr_accessor :doctor, :params

  def parse_date(date)
    if date.is_a?(String)
      Date.parse(date)
    end
  end
end
