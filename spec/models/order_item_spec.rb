require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  let(:book) { create :book }
  subject { create :order_item, book: book }

  it { should belong_to :book }
  it { should belong_to :order }

  context "validation" do
    it { should validate_presence_of :quantity }
    # it { should validate_presence_of :order }
    it { should validate_presence_of :book }
  end

  describe "#price" do
    it "returns correct price" do
      expect(subject.price).to eq subject.book_price * subject.quantity
    end
  end


  describe "#to_s" do
    it "returns book name with quantity" do
      expect(subject.to_s).to eq "#{book.title} x#{subject.quantity}"
    end
  end
end
