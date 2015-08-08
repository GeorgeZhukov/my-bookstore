  class OrdersController < ApplicationController
  load_and_authorize_resource

  add_breadcrumb (I18n.t"orders.orders"), :orders_path

  def index

  end

  def show
    add_breadcrumb "Order ##{@order.number}", @order # todo i18n variable
  end
end
