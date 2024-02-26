class CreateJoinTableUsersPayments < ActiveRecord::Migration[7.1]
  def change
    create_join_table :users, :payments do |t|
      t.references :sender, foreign_key: { to_table: :users }
      t.references :receiver, foreign_key: { to_table: :users }
      t.index [:user_id, :payment_id]
      t.index [:payment_id, :user_id]
    end
  end
end
