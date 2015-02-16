class CreateBitCoins < ActiveRecord::Migration
  def change
    create_table :bit_coins do |t|
      t.string :wallet_address
      t.string :user_email
      t.float :balance
      t.float :app_price

      t.timestamps
    end
  end
end
