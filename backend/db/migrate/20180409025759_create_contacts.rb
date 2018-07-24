class CreateContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :contacts do |t|
      t.references :user, foreign_key: true, index: { unique: true }
      t.string :website
      t.string :email

      t.timestamps
    end
  end
end
