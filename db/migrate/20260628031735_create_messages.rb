class CreateMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :messages do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.boolean :is_read, null: false, default: false
      t.references :sender, null: false, foreign_key: { to_table: :users }
      t.references :receiver, null: false, foreign_key: { to_table: :users }
      t.references :pet, null: false, foreign_key: true
      t.references :application, null: false, foreign_key: { to_table: :adoption_applications }

      t.timestamps
    end
    add_index :messages, :receiver_id
    add_index :messages, :is_read
  end
end
