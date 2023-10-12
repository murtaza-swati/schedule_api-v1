# == Schema Information
#
# Table name: appointments
#
#  id           :integer          not null, primary key
#  doctor_id    :integer
#  patient_name :string
#  start_time   :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require "test_helper"

RSpec.describe Appointment do
  let(:doctor) do
    Doctor.create(
      name: "Dr. John Doe",
      work_start_time: Time.parse("9:00 AM"),
      work_end_time: Time.parse("5:00 PM"),
      slot_duration: 55,
      break_duration: 5
    )
  end

  describe "validations" do
  end
end
