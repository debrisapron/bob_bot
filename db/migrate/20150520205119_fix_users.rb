class FixUsers < ActiveRecord::Migration
  def change
    change_column :users, :type, :string, null: true
  end
end
