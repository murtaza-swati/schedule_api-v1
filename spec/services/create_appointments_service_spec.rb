require "test_helper"

RSpec.describe CreateAppointmentsService do
  let(:doctor) { create(:doctor) }
  let(:params) { {} }

  describe ".call" do
    subject { described_class.call(doctor, params) }

    before do
      subject
    end

    context "with single appointment" do
      let(:params) do
        {appointment: {patient_name: "John Doe", start_time: "05-10-2023 09:00 AM"}}
      end

      it "builds and save appointment" do
        expect(doctor.appointments.count).to eq(1)
      end

      it "returns code and appointment" do
        expect(subject).to eq([201, [Appointment::Presenter.new(doctor.appointments.first).to_h]])
      end
    end

    context "with multiple appointments" do
      let(:params) do
        {appointments: [
          {patient_name: "John Doe", start_time: "05-10-2023 09:00 AM"},
          {patient_name: "Jane Doe", start_time: "05-10-2023 10:00 AM"}
        ]}
      end

      it "builds and save appointment" do
        expect(doctor.appointments.count).to eq(2)
      end
    end

    context "with invalid appointment" do
      let(:params) do
        {appointment: {patient_name: "John Doe", start_time: "05-10-2023 07:00 AM"}}
      end

      before do
        allow_any_instance_of(Appointment).to receive(:save).and_return(false)
      end

      it "do not save appointment" do
        expect(doctor.appointments.count).to eq(0)
      end

      it "returns appointment" do
        expect(subject).to eq([400, [{errors: {start_time: ["must be within the doctor's working hours"]}}]])
      end
    end
  end
end
