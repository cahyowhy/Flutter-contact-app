class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :surname
      t.string :address
      t.date :dob
      t.string :about
      t.string :image_profile

      t.timestamps
    end
  end
end
