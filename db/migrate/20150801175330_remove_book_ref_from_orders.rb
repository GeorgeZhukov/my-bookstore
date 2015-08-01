class RemoveBookRefFromOrders < ActiveRecord::Migration
  def change
    remove_column :orders, :book_id
  end
end
