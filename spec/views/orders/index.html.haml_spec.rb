require 'rails_helper'

RSpec.describe "orders/index.html.haml", type: :view do
  let(:user) { create :user }

  before do
    allow(view).to receive(:current_user).and_return(user)
  end

  it "renders the orders collection partial" do
    5.times { create(:order, state: "in_queue") }
    assign(:orders, Order.all)
    render
    expect(view).to render_template(partial: "orders/_orders", count: 1)
  end

  it "renders the order partial" do
    order = create(:order, state: "in_progress", user: user)
    order.add_book create(:book)
    assign(:orders, Order.all)
    render
    expect(view).to render_template(partial: "orders/_order", count: 1)
  end

  it "renders 'no orders' when orders is empty" do
    assign(:orders, Order.all)
    render
    expect(rendered).to match I18n.t("orders.index.no_orders")
  end

  it "renders 'cart is empty' when order in progress is empty " do
    create :order, state: :in_progress, user: user
    assign(:orders, Order.all)
    render
    expect(rendered).to match I18n.t("orders.index.shopping_cart_is_empty")
  end
end
