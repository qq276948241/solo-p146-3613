class CreateAdoptionApplications < ActiveRecord::Migration[8.1]
  def change
    create_table :adoption_applications do |t|
      t.string :status, null: false, default: 'pending'
      t.string :applicant_name, null: false
      t.string :applicant_phone, null: false
      t.string :applicant_wechat
      t.string :experience
      t.text :reason
      t.references :pet, null: false, foreign_key: true
      t.references :applicant, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
    add_index :adoption_applications, :status
    add_index :adoption_applications, [:pet_id, :applicant_id], unique: true
  end
end
