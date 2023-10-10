class CreateOrganizations < ActiveRecord::Migration[7.0]
  def change
    create_table :organizations do |t|
      t.string :name
      t.string :email
      t.string :api_key_digest
      t.string :token

      t.timestamps
    end

    add_index :organizations, :email, unique: true
  end
end
