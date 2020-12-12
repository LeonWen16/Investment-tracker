class CreateSecurities < ActiveRecord::Migration[6.0]
  def change
    create_table :securities do |t|
      t.string :company_name
      t.string :ticker
      t.float :average_price
      t.float :last_price
      t.float :current_price
      t.integer :owner_id
      t.integer :number_of_shares

      t.timestamps
    end
  end
end
