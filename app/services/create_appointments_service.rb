class CreateAppointmentsService
  def self.call(*args)
    new(*args).call
  end

  def initialize(doctor, params)
    self.doctor = doctor
    self.params = params
  end

  def call
    self.result = if params[:appointments].present?
      params[:appointments].map do |appointment_params|
        create_appointment(appointment_params)
      end
    else
      [create_appointment(params[:appointment])]
    end
    result
  end

  def result
    if @result&.any? { _1[:errors] }
      [400, @result]
    else
      [201, @result]
    end
  end

  private

  attr_accessor :doctor, :params
  attr_writer :result

  def create_appointment(appointment_params)
    appointment = doctor.appointments.build(appointment_params)
    if appointment.save
      Appointment::Presenter.new(appointment).to_h
    else
      {errors: appointment.errors.messages}
    end
  end
end
