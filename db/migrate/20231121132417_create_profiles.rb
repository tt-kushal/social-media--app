class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.string :username
      t.string :full_name
      t.string :phone_number
      t.date :date_of_birth
      t.integer :post_count
      t.text :bio
      t.integer :age
      t.string :gender
      t.string :country
      t.string :state
      t.string :address
      t.references :user, null: false, foreign_key: true, unique: true
      t.timestamps
    end
  end
end