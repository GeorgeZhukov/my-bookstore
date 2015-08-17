require 'rails_helper'

RSpec.describe Order, type: :model do
  subject { FactoryGirl.create :order }
  let(:book) { FactoryGirl.create :book }

  it { expect(subject).to belong_to :billing_address }
  it { expect(subject).to belong_to :shipping_address }
  it { expect(subject).to belong_to :credit_card }
  it { expect(subject).to belong_to :user }
  it { expect(subject).to belong_to :delivery_service }
  it { expect(subject).to validate_presence_of :user }
  it { expect(subject).to have_many :order_items }

  it "generates number" do
    expect(subject.number).not_to be_nil
  end

  it "init total_price" do
    expect(subject.total_price).not_to be_nil
  end

  describe "#finish" do
    subject { FactoryGirl.create :order, state: "delivered"}

    before do
      allow(subject).to receive(:notify_user).once
    end

    it "sets completed_date" do
      expect { subject.complete }.to change { subject.completed_date }
    end

    it "calls .notify_user" do
      expect(subject).to receive(:notify_user)
      subject.complete
    end

    it "raise an error if state isn't delivered" do
      order = FactoryGirl.create :order
      expect { order.complete }.to raise_error(/Wrong state/)
    end
  end

  describe "#add_book" do

    it "creates order item with given book and sets quantity to one by default" do
      subject.add_book book
      order_item = OrderItem.first
      expect(order_item.book).to eq book
      expect(order_item.quantity).to eq 1
    end

    it "increase quantity by one when same book added" do
      subject.add_book book
      subject.add_book book
      order_item = OrderItem.first
      expect(order_item.quantity).to eq 2
    end

    context "total price" do
      before do
        subject.clear
      end

      it "updates total price to book price" do
        subject.add_book book
        expect(subject.total_price).to eq book.price
      end

      it "updates total price to 2x book price" do
        subject.add_book(book, 2)
        expect(subject.total_price).to eq book.price * 2
      end

      it "updates total price with 2 different books" do
        book2 = FactoryGirl.create :book
        subject.add_book book
        subject.add_book book2
        expect(subject.total_price).to eq book.price + book2.price
      end
    end
  end

  describe "#books_count" do
    it "returns zero if no order items" do
      expect(subject.books_count).to eq 0
    end

    it "returns 1 if one order item with quantity eq to 1" do
      subject.order_items << FactoryGirl.create(:order_item, quantity: 1)
      expect(subject.books_count).to eq 1
    end

    it "returns 2 if one order item with quantity eq to 2" do
      subject.order_items << FactoryGirl.create(:order_item, quantity: 2)
      expect(subject.books_count).to eq 2
    end

    it "returns 8 if one order item with quantity eq to 3 and second eq to 5" do
      subject.order_items << FactoryGirl.create(:order_item, quantity: 3)
      subject.order_items << FactoryGirl.create(:order_item, quantity: 5)
      expect(subject.books_count).to eq 8
    end
  end

  describe "#empty?" do

    it "returns true when no order items" do
      expect(subject).to be_empty
    end

    it "returns false when has some order items" do
      subject.add_book FactoryGirl.create(:book)
      expect(subject).not_to be_empty
    end
  end

  describe "#clear" do
    before do
      book = FactoryGirl.create :book
      delivery_service = FactoryGirl.create :delivery_service
      billing_address = FactoryGirl.create :address
      shipping_address = FactoryGirl.create :address

      subject.add_book book
      subject.delivery_service = delivery_service
      subject.billing_address=billing_address
      subject.shipping_address=shipping_address
      subject.clear
    end

    it "removes order items" do
      expect(subject).to be_empty
    end

    # it "removes shipping address" do
    #   expect(subject.shipping_address).to be_nil
    # end
    #
    # it "removes billing address" do
    #   expect(subject.billing_address).to be_nil
    # end

    it "removes delivery service" do
      expect(subject.delivery_service).to be_nil
    end

    it "updates total price to 0" do
      expect(subject.total_price).to be_zero
    end
  end

  describe "#notify_user" do
    xit "sends an email" do
      expect { subject.send(:notify_user) }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

    it "updates completed_date" do
      expect { subject.send(:notify_user) }.to change { subject.completed_date }.from(nil)
    end
  end

  describe "#take_books" do
    xit "calls OrderItem.take_books" do
      subject.take_books
      # expect().to
    end
  end

  describe "#restore_books" do
    xit "calls OrderItem.restore_books" do

    end
  end

  describe "#calculate_total_price" do
    it "returns .calculate_books_price when no delivery service"
    it "returns sum of .calculate_books_price and delivery service price"
  end

  describe "#calculate_books_price" do
    it "returns 0 when no books"
    it "returns price of one book multiple by quantity"
    it "returns a sum of prices of different books multiply by quantity"
  end

  describe "#generate_number" do
    it "generates number in format 'R000000000'"
  end

  describe "#title" do
    it "returns .to_s" do
      expect(subject.title).to eq subject.to_s
    end
  end

  describe "#to_s" do
    it "returns Order #(number)" do
      expect(subject.to_s).to eq "Order ##{subject.number}"
    end
  end
end
