class CreateHempayAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :hempay_accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :balance, precision: 15, scale: 2, default: 0.0
      t.string :account_number
      t.string :account_name
      t.string :bank_name
      t.boolean :active, default: true
      t.string :currency_type, default: 'NGN'

      t.timestamps
    end
  end
end
