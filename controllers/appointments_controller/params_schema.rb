require "dry-schema"

class AppointmentsController
  ParamsSchema = Dry::Schema.Params do
    required(:doctor_id).filled(:integer)
    optional(:appointment_id).filled(:integer)
    optional(:appointments).value(:array).each do
      schema do
        required(:patient_name).filled(:string)
        required(:start_time).filled(:string)
      end
    end
    optional(:appointment).schema do
      required(:patient_name).filled(:string)
      required(:start_time).filled(:string)
    end
  end
end
