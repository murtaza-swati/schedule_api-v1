# Endpoint to find a doctors working hours
# Endpoint to book a doctors open slot
# Endpoint to update a doctors appointment
# Endpoint to delete a doctors appointment
# Endpoint to view a doctors availability
class Router < Sinatra::Base
  helpers Authentication

  before "/api/*" do
    return if authenticated?
    halt 403, {error: errors.join(" ")}.to_json
  end

  get "/api/v1" do
    {message: "pong"}.to_json
  end

  post "/exchange_key" do
    exchange_key.to_json
  end

  get "/api/v1/doctors/:doctor_id/hours" do
    DoctorsController.call(:availability, params).to_json
  end

  get "/api/v1/doctors/:doctor_id/availability" do
    AppointmentsController.call(:index, params).to_json
  end

  post "/api/v1/doctors/:doctor_id/appointments" do
    code, response = AppointmentsController.call(:create, params)
    status code
    response.to_json
  end

  put "/api/v1/doctors/:doctor_id/appointments/:appointment_id" do
    code, response = AppointmentsController.call(:update, params)
    status code
    response.to_json
  end

  delete "/api/v1/doctors/:doctor_id/appointments/:appointment_id" do
    code, response = AppointmentsController.call(:delete, params)
    status code
    response&.to_json
  end
end
