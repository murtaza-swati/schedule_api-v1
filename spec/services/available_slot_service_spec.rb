require "test_helper"

RSpec.describe AvailableSlotService do
  let(:start_time) { Date.parse("05-10-2023") }
  let(:end_time) { Date.parse("06-10-2023") }

  let(:doctor) do
    Doctor.create!(
      name: "Dr. John Doe",
      work_start_time: Time.parse("9:00 AM UTC"),
      work_end_time: Time.parse("5:00 PM UTC"),
      slot_duration: 55,
      break_duration: 5
    )
  end

  let(:service) do
    described_class.new(doctor, start_time: start_time, end_time: end_time)
  end

  describe ".call" do
    before do
      allow(AvailableSlotService).to receive(:new).and_return(service)
    end

    it "calls new" do
      described_class.call(doctor)
      expect(AvailableSlotService).to have_received(:new)
    end
  end

  describe "#call" do
    subject { service.call }

    context "when there are no appointments" do
      let(:result) do
        {
          "05-10-2023" => ["09:00 AM UTC - 05:00 PM UTC"], # we cannot exceed 5:00 PM UTC because it would mean that the appointment would end after the doctor's working hours.
          "06-10-2023" => ["09:00 AM UTC - 05:00 PM UTC"]
        }
      end

      it "returns all slots" do
        expect(subject).to eq(result)
      end
    end

    context "when there are appointments" do
      let(:result) do
        {
          "05-10-2023" => [
            "09:00 AM UTC - 11:00 AM UTC",
            "12:00 PM UTC - 01:00 PM UTC",
            "02:00 PM UTC - 05:00 PM UTC"
          ],
          "06-10-2023" => ["09:00 AM UTC - 05:00 PM UTC"]
        }
      end

      before do
        Appointment.create!(
          doctor_id: doctor.id,
          start_time: DateTime.parse("05-10-2023 11:00 AM UTC"),
          patient_name: "John Doe"
        )
        Appointment.create!(
          doctor_id: doctor.id,
          start_time: DateTime.parse("05-10-2023 01:00 PM UTC"),
          patient_name: "John Doe"
        )
      end

      it "returns available slots" do
        expect(subject).to eq(result)
      end
    end
  end
end
