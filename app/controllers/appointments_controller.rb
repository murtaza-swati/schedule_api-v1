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

  private

  attr_accessor :doctor, :params
end
