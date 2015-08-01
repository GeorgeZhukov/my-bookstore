class AddCreditCardRefToOrders < ActiveRecord::Migration
  def change
    add_reference :orders, :credit_card, index: true, foreign_key: true
  end
end
