class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :text, null: false
      t.belongs_to :user, null: false, foreign_key: true
    end
  end
end
