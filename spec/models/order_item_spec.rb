require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  let(:book) { FactoryGirl.create :book }
  subject { FactoryGirl.create :order_item, book: book }

  it { expect(subject).to validate_presence_of :quantity }
  it { expect(subject).to belong_to :book }
  it { expect(subject).to belong_to :order }

  describe ".price" do
    it "returns correct price" do
      expect(subject.price).to eq subject.book_price * subject.quantity
    end
  end

  describe ".take_books" do
    it "decrease book.books_in_stock property by quantity" do
      books_in_stock = book.books_in_stock
      subject.take_books
      expect(book.books_in_stock).to eq books_in_stock - subject.quantity
    end
  end

  describe ".restore_books" do
    it "increase book.books_in_stock property by quantity" do
      books_in_stock = book.books_in_stock
      subject.restore_books
      expect(book.books_in_stock).to eq books_in_stock + subject.quantity
    end
  end

  describe ".to_s" do
    it "returns book name with quantity" do
      expect(subject.to_s).to eq "#{book.title} x#{subject.quantity}"
    end
  end
end
