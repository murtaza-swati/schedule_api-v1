require "test_helper"

RSpec.describe Appointment do
  let(:doctor) do
    Doctor.create(
      name: "Dr. John Doe",
      work_start_time: Time.parse("9:00 AM"),
      work_end_time: Time.parse("5:00 PM"),
      slot_duration_in_minutes: 55,
      break_duration_in_minutes: 5
    )
  end

  describe "validations" do
  end
end
