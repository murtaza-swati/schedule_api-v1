require "test_helper"

RSpec.describe Appointment::Presenter do
  subject { described_class.new(appointment) }
  let(:appointment) { create(:appointment, start_time: DateTime.parse(start_time)) }
  let(:start_time) { "12-10-2023 10:00" }
  let(:end_time) { "12-10-2023 10:55" }

  describe "#formatted_start_time" do
    it "returns the formatted start time" do
      expect(subject.formatted_start_time).to eq(start_time)
    end
  end

  describe "#formatted_end_time" do
    it "returns the formatted end time" do
      expect(subject.formatted_end_time).to eq(end_time)
    end
  end

  describe "#to_h" do
    it "returns a hash of the appointment" do
      expect(subject.to_h).to eq({
        id: appointment.id,
        patient_name: appointment.patient_name,
        start_time: start_time,
        end_time: end_time
      })
    end
  end
end
