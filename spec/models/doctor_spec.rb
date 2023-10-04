# == Schema Information
#
# Table name: doctors
#
#  id                        :integer          not null, primary key
#  name                      :string
#  work_start_time           :time
#  work_end_time             :time
#  slot_duration_in_minutes  :integer
#  appointment_slot_limit    :integer
#  break_duration_in_minutes :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#
require 'test_helper'

RSpec.describe Doctor do
  let(:doctor) do
    Doctor.new(
      name: 'Dr. John Doe',
      work_start_time: start_time,
      work_end_time: end_time,
      slot_duration_in_minutes: 55,
      break_duration_in_minutes: 5,
    )
  end

  describe '#appointment_within_working_hours?' do
    let(:start_time) { Time.parse('9:00 AM UTC') }
    let(:end_time) { Time.parse('5:00 PM UTC') }

    context "within working hours" do
      let(:appointment_time) { Time.parse('11:00 AM UTC') }
      it 'returns true' do
        expect(doctor.appointment_within_working_hours?(appointment_time)).to eq(true)
      end
    end

    context "outside working hours" do
      let(:appointment_time) { Time.parse('8:00 AM UTC') }

      it 'returns false' do
        expect(doctor.appointment_within_working_hours?(appointment_time)).to eq(false)
      end
    end
  end
end
