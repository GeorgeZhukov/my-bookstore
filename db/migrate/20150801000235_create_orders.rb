class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.datetime :completed_date
      t.string :state
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :book, index: true, foreign_key: true
      t.belongs_to :delivery_service, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
