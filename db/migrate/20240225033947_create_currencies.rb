class CreateCurrencies < ActiveRecord::Migration[7.1]
  def change
    create_table :currencies do |t|
      t.string :name
      t.string :code
      t.string :symbol
      t.decimal :exchange_rate, precision: 10, scale: 2

      t.timestamps
    end

    add_index :currencies, :code, unique: true
  end
end
