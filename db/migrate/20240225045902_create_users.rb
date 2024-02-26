class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :first_name
      t.string :last_name
      t.string :middle_name
      t.date :date_of_birth
      t.string :employment_status
      t.string :bvn
      t.boolean :kyc_status
      t.string :home_address
      t.string :office_address
      t.string :phone_number
      t.boolean :can_transact

      t.timestamps
    end
    add_index :users, :username, unique: true
  end
end
