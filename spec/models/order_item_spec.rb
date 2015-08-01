require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  # it { expect(subject).to validate_presence_of :price }
  it { expect(subject).to validate_presence_of :quantity }
  it { expect(subject).to belong_to :book }
  it { expect(subject).to belong_to :order }

  describe ".price" do
    subject { FactoryGirl.create :order_item }

    it "returns correct price" do
      expect(subject.price).to eq subject.book.price * subject.quantity
    end
  end
end
