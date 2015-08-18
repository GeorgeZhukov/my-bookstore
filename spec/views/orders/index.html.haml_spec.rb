require 'rails_helper'

RSpec.describe "orders/index.html.haml", type: :view do

  xit "renders the correct partial" do
    orders = []
    5.times { orders << FactoryGirl.create(:order, state: "in_queue") }
    user = FactoryGirl.create :user
    allow(view).to receive(:current_or_guest_user).and_return(user)
    assign(:orders, Order.all)
    render
    expect(view).to render_template(partial: "orders/_order", count: 5)
  end
end
