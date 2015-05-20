class AddAddresseeToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :addressee_id, :int
    add_foreign_key :messages, :users, column: :addressee_id
  end
end
