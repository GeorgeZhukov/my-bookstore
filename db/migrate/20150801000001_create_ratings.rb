class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.text :review
      t.integer :number
      t.belongs_to :book, index: true, foreign_key: true
      t.belongs_to :user, index: true, foreign_key: true
      t.string :state

      t.timestamps null: false
    end
  end
end
