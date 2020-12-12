class AddBaseToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :base, :float
  end
end
