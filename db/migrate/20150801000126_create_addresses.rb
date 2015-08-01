class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.text :address
      t.string :zip_code
      t.string :city
      t.string :phone
      t.belongs_to :user, index: true, foreign_key: true
      t.string :country

      t.timestamps null: false
    end
  end
end
