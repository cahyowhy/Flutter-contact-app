class CreatePhoneNumbers < ActiveRecord::Migration[5.1]
  def change
    create_table :phone_numbers do |t|
      t.references :contact, foreign_key: true
      t.string :phone_number

      t.timestamps
    end
  end
end
