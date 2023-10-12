require "test_helper"

RSpec.describe AppointmentsController do
  describe ".call" do
    context "when doctor is not found" do
      it "returns an error message" do
        expect(AppointmentsController.call(:action, {})).to eq({error: {doctor_id: ["is missing"]}})
      end
    end

    context "when doctor is found" do
      let(:doctor) { instance_double(Doctor) }
      let(:params) { {doctor_id: 1} }

      before do
        allow(Doctor).to receive(:find_by).with(id: params[:doctor_id]).and_return(doctor)
        allow_any_instance_of(AppointmentsController).to receive(:index).and_return({})
      end

      it "calls the action method on a new instance of the controller" do
        expect_any_instance_of(AppointmentsController).to receive(:index)
        AppointmentsController.call(:index, params)
      end
    end
  end

  describe "#index" do
    let(:doctor) { instance_double(Doctor) }
    let(:params) { {doctor_id: 1} }

    before do
      allow(Doctor).to receive(:find_by).and_return(doctor)
    end

    it "calls AvailableSlotService" do
      expect(AvailableSlotService)
        .to receive(:call)
        .with(doctor, start_date: nil, end_date: nil)
        .and_return({})
      AppointmentsController.call(:index, params)
    end
  end

  describe "#create" do
    let(:doctor) { instance_double(Doctor) }
    let(:params) { {doctor_id: 1} }

    before do
      allow(Doctor).to receive(:find_by).and_return(doctor)
    end

    it "calls CreateAppointmentService" do
      expect(CreateAppointmentsService)
        .to receive(:call)
        .with(doctor, params)
        .and_return({})
      AppointmentsController.call(:create, params)
    end
  end
end
