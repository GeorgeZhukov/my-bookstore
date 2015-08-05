  class OrdersController < ApplicationController
  load_and_authorize_resource

  add_breadcrumb "Orders", :orders_path

  def index

  end

  def show
    add_breadcrumb "Order ##{@order.number}", @order
  end
end
