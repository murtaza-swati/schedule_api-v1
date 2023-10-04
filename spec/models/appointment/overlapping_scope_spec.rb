require 'test_helper'

RSpec.describe Appointment::OverlappingScope do
  let(:appointment_id) { 1 }
  let(:doctor_id) { 2 }
  let(:start_time) { DateTime.parse('04.10.2023 10:30 AM') }
  let(:slot_duration) { 55 }
  let(:break_duration) { 5 }

  subject do
    described_class.new(
      appointment_id: appointment_id,
      doctor_id: doctor_id,
      start_time: start_time,
      slot_duration: slot_duration,
      break_duration: break_duration
    )
  end

  describe '#call' do
    it 'do not rise error' do
      expect { subject.call }.not_to raise_error
    end

    it 'generates the correct SQL' do
      expect(subject.call.to_sql.squish).to eq(
        <<-SQL.squish,
        SELECT "appointments".* FROM "appointments" WHERE "appointments"."doctor_id" = 2 AND ( (start_time <= '2023-10-04 11:25:00' AND datetime(start_time, '+55 minutes') > '2023-10-04 10:30:00') OR ('2023-10-04 10:30:00' < datetime('2023-10-04 11:25:00', '+5 minutes') AND '2023-10-04 10:30:00' >= '2023-10-04 11:25:00') ) AND "appointments"."id" != 1
        SQL
      ), subject.call.to_sql.squish
    end

    context "with database records" do
      let(:appointment_id) { nil }
      let(:doctor_id) { doctor.id }

      let(:doctor) do
        Doctor.create!(
          name: 'Dr. John Doe',
          work_start_time: Time.parse('9:00 AM').to_formatted_s(:db),
          work_end_time: Time.parse('5:00 PM').to_formatted_s(:db),
          slot_duration_in_minutes: 55,
          break_duration_in_minutes: 5
        )
      end

      before do
        Appointment.create!(
          doctor_id: doctor_id,
          start_time: DateTime.parse('04.10.2023 10:00 AM').to_formatted_s(:db),
          patient_name: 'John Doe'
        )
      end

      it 'returns the correct records' do
        expect(subject.call.count).to eq(1)
      end
    end
  end
end
