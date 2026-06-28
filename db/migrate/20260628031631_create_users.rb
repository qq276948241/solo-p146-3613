class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :phone, null: false
      t.string :password_digest, null: false
      t.string :nickname
      t.string :avatar_url
      t.string :wechat
      t.string :real_name
      t.text :experience

      t.timestamps
    end
    add_index :users, :phone, unique: true
  end
end
