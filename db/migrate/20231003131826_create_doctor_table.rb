class CreateDoctorTable < ActiveRecord::Migration[7.0]
  def change
    create_table :doctors do |t|
      t.string :name
      # NOTE: in pgsql the start and and end can be replaced by 1 column of type tsrange
      t.time :work_start_time  # Begin of working hours
      t.time :work_end_time    # End of working hours
      t.integer :slot_duration_in_minutes
      t.integer :appointment_slot_limit  # Can be used to limit the number of appointments per day
      t.integer :break_duration_in_minutes

      t.timestamps
    end

  end
end
