class AppointmentsController
  def self.call(action, params)
    params = ParamsSchema.call(params)
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
      start_date: params[:start_date],
      end_date: params[:end_date]
    )
  end

  def create
    # REFACTOR: Move this check logic to schema validation level
    if params[:appointments].present? || params[:appointment].present?
      CreateAppointmentsService.call(doctor, params)
    else
      [400, {error: "No appointments to create"}]
    end
  end

  def update
    # REFACTOR: Move this to similar service as CreateAppointmentsService or combine them in one
    appointment = doctor.appointments.find_by(id: params[:appointment_id])
    if params[:appointment].present? && appointment&.update(params[:appointment])
      [200, Appointment::Presenter.new(appointment).to_h]
    else
      [400, update_error(appointment)]
    end
  end

  def delete
    # REFACTOR: Move this to similar service as CreateAppointmentsService or combine them in one
    appointment = doctor.appointments.find_by(id: params[:appointment_id])
    return 204 if appointment&.destroy

    [400, {error: "Appointment not found"}]
  end

  private

  attr_accessor :doctor, :params

  # REFACTOR: Use null object pattern for appointment and this method can be
  # removed
  def update_error(appointment)
    if appointment&.errors&.any?
      {error: appointment.errors.messages}
    else
      {error: "Appointment not found"}
    end
  end
end
