class AddTypeToUser < ActiveRecord::Migration
  def change
    execute "DELETE FROM messages; DELETE FROM users;"
    add_column :users, :type, :string, null: false
  end
end
