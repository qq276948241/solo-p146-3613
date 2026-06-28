class CreatePets < ActiveRecord::Migration[8.1]
  def change
    create_table :pets do |t|
      t.string :name, null: false
      t.string :species, null: false
      t.string :breed
      t.string :size
      t.integer :age_months
      t.string :gender
      t.string :source, null: false
      t.string :status, null: false, default: 'listed'
      t.text :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :pets, :species
    add_index :pets, :status
    add_index :pets, :source
  end
end
