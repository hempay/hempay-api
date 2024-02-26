class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.decimal :amount
      t.date :payment_date
      t.string :description
      t.string :status
      t.string :currency_code, null: false

      t.timestamps

    end
  
    add_foreign_key :payments, :currencies, column: :currency_code, primary_key: :code
  end
end
