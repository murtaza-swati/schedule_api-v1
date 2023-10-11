class CreateAppointmentsService
  def self.call(*args)
    new(*args).call
  end

  def initialize(doctor, params)
    self.doctor = doctor
    self.params = params
  end

  def call
    if params[:appointments].present?
      params[:appointments].map do |appointment_params|
        create_appointment(appointment_params)
      end
    else
      create_appointment(params[:appointment])
    end
  end

  private

  attr_accessor :doctor, :params

  def create_appointment(appointment_params)
    appointment = doctor.appointments.build(appointment_params)
    if appointment.save
      AppointmentPresenter.new(appointment).to_h
    else
      appointment.errors
    end
  end
end
