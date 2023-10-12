# == Schema Information
#
# Table name: doctors
#
#  id                     :integer          not null, primary key
#  name                   :string
#  work_start_time        :time
#  work_end_time          :time
#  slot_duration          :integer
#  appointment_slot_limit :integer
#  break_duration         :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
require "test_helper"

RSpec.describe Doctor do
  let(:start_time) { Time.parse("9:00 AM UTC") }
  let(:end_time) { Time.parse("5:00 PM UTC") }
  let(:slot_duration) { 55 }
  let(:break_duration) { 5 }
  let(:name) { "Dr. John Doe" }

  let(:doctor) do
    Doctor.new(
      name: name,
      work_start_time: start_time,
      work_end_time: end_time,
      slot_duration: slot_duration,
      break_duration: break_duration
    )
  end

  describe "validations" do
    subject { doctor }

    it { is_expected.to be_valid }

    context "when name is not present" do
      let(:name) { nil }

      it { is_expected.to be_invalid }
    end

    context "when work_start_time is missing" do
      let(:start_time) { nil }

      it { is_expected.to be_invalid }
    end

    context "when work_end_time is missing" do
      let(:end_time) { nil }

      it { is_expected.to be_invalid }
    end

    context "when slot_duration is missing" do
      let(:slot_duration) { nil }

      it { is_expected.to be_invalid }
    end

    context "when break_duration is missing" do
      let(:break_duration) { nil }

      it { is_expected.to be_invalid }
    end

    context "when work_start_time is after work_end_time" do
      let(:start_time) { Time.parse("5:00 PM UTC") }
      let(:end_time) { Time.parse("9:00 AM UTC") }

      it "is invalid" do
        expect(subject).to be_invalid
      end
    end

    context "when work_start_time is equal to work_end_time" do
      let(:start_time) { Time.parse("5:00 PM UTC") }
      let(:end_time) { Time.parse("5:00 PM UTC") }

      it "is invalid" do
        expect(subject).to be_invalid
      end
    end

    context "when slot_duration is greater than work duration" do
      let(:slot_duration) { 9 * 60 }

      it "is invalid" do
        expect(subject).to be_invalid
      end
    end
  end

  describe "#appointment_within_working_hours?" do
    context "within working hours" do
      let(:appointment_time) { Time.parse("11:00 AM UTC") }
      it "returns true" do
        expect(doctor.appointment_within_working_hours?(appointment_time)).to eq(true)
      end
    end

    context "outside working hours" do
      let(:appointment_time) { Time.parse("8:00 AM UTC") }

      it "returns false" do
        expect(doctor.appointment_within_working_hours?(appointment_time)).to eq(false)
      end
    end
  end
end
