require 'rails_helper'

RSpec.describe CartHelper, type: :helper do
  describe "#compare_address" do
    it "returns positive if addresses is the same" do
      address = create :address
      order = create :order, shipping_address: address, billing_address: address
      expect(helper.compare_address(order, true, false)).to be_truthy
    end

    it "returns negative if addresses is NOT the same" do
      order = create :order
      expect(helper.compare_address(order, true, false)).to be_falsey
    end
  end
end
