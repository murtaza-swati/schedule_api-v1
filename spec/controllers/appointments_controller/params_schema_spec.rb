require "test_helper"

RSpec.describe AppointmentsController::ParamsSchema do
  let(:schema) { described_class }

  describe "doctor_id" do
    it "is required" do
      result = schema.call({})

      expect(result.errors.to_h).to include(:doctor_id)
    end

    it "must be an integer" do
      result = schema.call(doctor_id: "not an integer")

      expect(result.errors.to_h).to include(:doctor_id)
    end
  end

  describe "appointment_id" do
    it "is optional" do
      result = schema.call(doctor_id: 1)

      expect(result.errors.to_h).not_to include(:appointment_id)
    end

    it "must be an integer" do
      result = schema.call(doctor_id: 1, appointment_id: "not an integer")

      expect(result.errors.to_h).to include(:appointment_id)
    end
  end

  describe "appointments" do
    it "is optional" do
      result = schema.call(doctor_id: 1)

      expect(result.errors.to_h).not_to include(:appointments)
    end

    it "must be an array" do
      result = schema.call(doctor_id: 1, appointments: "not an array")
      expect(result.errors.to_h).to include(:appointments)
    end

    it "can contain multiple appointment objects" do
      result = schema.call(
        doctor_id: 1,
        appointments: [
          {patient_name: "John Doe", start_time: "2022-01-01T00:00:00Z"},
          {patient_name: "Jane Doe", start_time: "2022-01-02T00:00:00Z"}
        ]
      )

      expect(result.errors.to_h).not_to include(:appointments)
    end

    describe "appointment object" do
      let(:appointment) { {patient_name: "John Doe", start_time: "2022-01-01T00:00:00Z"} }

      it "must have a patient_name" do
        result = schema.call(doctor_id: 1, appointments: [appointment.merge(patient_name: nil)])

        expect(result.errors.to_h).to include(:appointments)
      end

      it "must have a start_time" do
        result = schema.call(doctor_id: 1, appointments: [appointment.merge(start_time: nil)])

        expect(result.errors.to_h).to include(:appointments)
      end
    end
  end

  describe "appointment" do
    it "is optional" do
      result = schema.call(doctor_id: 1)

      expect(result.errors.to_h).not_to include(:appointment)
    end

    describe "appointment object" do
      let(:appointment) { {patient_name: "John Doe", start_time: "2022-01-01T00:00:00Z"} }

      it "must have a patient_name" do
        result = schema.call(doctor_id: 1, appointment: appointment.merge(patient_name: nil))

        expect(result.errors.to_h).to include(:appointment)
      end

      it "must have a start_time" do
        result = schema.call(doctor_id: 1, appointment: appointment.merge(start_time: nil))

        expect(result.errors.to_h).to include(:appointment)
      end
    end
  end
end
