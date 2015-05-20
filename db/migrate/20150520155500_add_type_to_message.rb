class AddTypeToMessage < ActiveRecord::Migration
  def change
    execute "DELETE FROM messages"
    add_column    :messages, :type,    :string, null: false
    change_column :messages, :text,    :string, null: true
    change_column :messages, :user_id, :int,    null: true
  end
end
