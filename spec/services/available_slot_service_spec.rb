require "test_helper"

RSpec.describe AvailableSlotService do
  let(:start_date) { Date.parse("05-10-2023") }
  let(:end_date) { Date.parse("06-10-2023") }

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
    described_class.new(doctor, start_date: start_date, end_date: end_date)
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

    context "with missing end_date" do
      let(:end_date) { nil }

      let(:result) do
        {
          "05-10-2023" => ["09:00 AM - 05:00 PM"],
          "06-10-2023" => ["09:00 AM - 05:00 PM"],
          "07-10-2023" => ["09:00 AM - 05:00 PM"],
          "08-10-2023" => ["09:00 AM - 05:00 PM"],
          "09-10-2023" => ["09:00 AM - 05:00 PM"],
          "10-10-2023" => ["09:00 AM - 05:00 PM"],
          "11-10-2023" => ["09:00 AM - 05:00 PM"]
        }
      end

      it "returns all slots for the next 7 days" do
        expect(subject).to eq(result)
      end
    end

    context "when there are no appointments" do
      let(:result) do
        {
          "05-10-2023" => ["09:00 AM - 05:00 PM"], # we cannot exceed 5:00 PM UTC because it would mean that the appointment would end after the doctor's working hours.
          "06-10-2023" => ["09:00 AM - 05:00 PM"]
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
            "09:00 AM - 11:00 AM",
            "12:00 PM - 01:00 PM",
            "02:00 PM - 05:00 PM"
          ],
          "06-10-2023" => ["09:00 AM - 05:00 PM"]
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
