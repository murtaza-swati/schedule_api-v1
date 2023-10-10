require "test_helper"

RSpec.describe DoctorsController do
  let(:doctor) { create(:doctor) }

  describe ".call" do
    let(:params) { {doctor_id: doctor.id} }

    context "when method is :availability" do
      let(:method) { :availability }

      it "calls availability on the doctor presenter" do
        expect_any_instance_of(Doctor::Presenter).to receive(:availability)
        described_class.call(method, params)
      end
    end

    context "when method is not :availability" do
      let(:method) { :invalid_method }

      it "raises a NoMethodError" do
        expect { described_class.call(method, params) }.to raise_error(NoMethodError)
      end
    end
  end
end
