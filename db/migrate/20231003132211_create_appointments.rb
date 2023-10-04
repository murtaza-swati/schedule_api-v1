class CreateAppointments < ActiveRecord::Migration[7.0]
  def change
    create_table :appointments do |t|
      t.belongs_to :doctor, foreign_key: true
      # NOTE: for MVP I don't need to create a patient table
      t.string :patient_name
      t.datetime :start_time

      t.timestamps
    end

    add_index :appointments, [:doctor_id, :start_time]
  end
end
