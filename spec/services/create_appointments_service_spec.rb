require "test_helper"

RSpec.describe CreateAppointmentsService do
  let(:doctor) { build_stubbed(:doctor) }
  let(:params) { {} }

  describe ".call" do
    subject { described_class.call(doctor, params) }

    before do
      subject
    end

    context "with single appointment" do
      let(:appointments) { [params] }

      let(:params) do
        {appointment: {patient_name: "John Doe", start_time: "05-10-2023 09:00 AM"}}
      end

      fit "calls new" do
        expect(described_class).to have_received(:new).with(doctor, appointments)
      end
    end

    context "with multiple appointments" do
      let(:appointments) { params }

      let(:params) do
        {appointments: [
          {patient_name: "John Doe", start_time: "05-10-2023 09:00 AM"},
          {patient_name: "Jane Doe", start_time: "05-10-2023 10:00 AM"}
        ]}
      end

      fit "calls new" do
        expect(described_class).to have_received(:new).with(doctor, appointments)
      end
    end
  end
end
