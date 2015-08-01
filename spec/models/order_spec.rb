require 'rails_helper'

RSpec.describe Order, type: :model do
  it { expect(subject).to belong_to :credit_card }
  it { expect(subject).to belong_to :delivery_service }
  it { expect(subject).to have_many :order_items }

  describe "#add_book" do
    before do
      @order = FactoryGirl.create :order
      @book = FactoryGirl.create :book
    end
    it "creates order item with given book and sets quantity to one by default" do
      @order.add_book @book
      order_item = OrderItem.first
      expect(order_item.book).to eq @book
      expect(order_item.quantity).to eq 1
    end

    it "increase quantity by one when same book added" do
      @order.add_book @book
      @order.add_book @book
      order_item = OrderItem.first
      expect(order_item.quantity).to eq 2
    end
  end

  describe "#calculate_total_price" do
    subject { FactoryGirl.create :order }

    it "returns zero when no books in order" do
      expect(subject.calculate_total_price).to be_zero
    end

    it "returns price of one book when only one book in order" do
      @book = FactoryGirl.create :book
      subject.add_book @book
      expect(subject.calculate_total_price).to eq @book.price + subject.delivery_service.price
    end

    it "returns price of two book when two book in order" do
      @book = FactoryGirl.create :book
      subject.add_book @book
      subject.add_book @book
      expect(subject.calculate_total_price).to eq @book.price * 2+ subject.delivery_service.price
    end

    it "returns correct total price for different books" do
      @book1 = FactoryGirl.create :book
      @book2 = FactoryGirl.create :book
      subject.add_book(@book1, 2)
      subject.add_book(@book2, 3)
      expected_total_price = @book1.price * 2 + @book2.price * 3
      expect(subject.calculate_total_price).to eq expected_total_price+ subject.delivery_service.price
    end
  end
end
