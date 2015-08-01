class AddShippingAddressRefAndBillingAddressRefToUsers < ActiveRecord::Migration
  def change
    add_column :users, :shipping_address_id, :integer
    add_column :users, :billing_address_id, :integer
  end
end
