class CreatePetImages < ActiveRecord::Migration[8.1]
  def change
    create_table :pet_images do |t|
      t.string :url, null: false
      t.references :pet, null: false, foreign_key: true

      t.timestamps
    end
    add_index :pet_images, :pet_id
  end
end
