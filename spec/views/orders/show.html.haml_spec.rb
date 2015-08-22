require 'rails_helper'

RSpec.describe "orders/show.html.haml", type: :view do
  let(:user) { create :user }
  let(:order) { create(:order, state: :in_queue, user: user) }

  before do
    allow(view).to receive(:current_user).and_return(user)
    order.add_book create(:book)
    assign(:order, order)
  end

  it "renders the order partial" do
    render
    expect(view).to render_template(partial: "orders/_order")
  end

  it "renders order number" do
    render
    expect(rendered).to match order.number
  end

  it "renders order state" do
    render
    expect(rendered).to match I18n.t("order_helper.#{order.state}")
  end
end
