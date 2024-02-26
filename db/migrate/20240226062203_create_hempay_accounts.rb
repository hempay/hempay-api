class CreateHempayAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :hempay_accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :balance

      t.timestamps
    end
  end
end
