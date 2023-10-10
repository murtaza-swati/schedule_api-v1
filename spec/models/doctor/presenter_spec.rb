require "test_helper"

RSpec.describe Doctor::Presenter do
  let(:doctor) { build_stubbed(:doctor) }
  let(:presenter) { described_class.new(doctor) }

  describe "#availability" do
    subject { presenter.availability }

    it "returns the doctor's availability" do
      expect(subject).to include(:working_hours)
    end
  end
end
