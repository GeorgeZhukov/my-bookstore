require 'rails_helper'

RSpec.describe Book, type: :model do
  subject { create :book }

  it { should belong_to :author }
  it { should belong_to :category }
  it { should have_many :ratings }

  context "validation" do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:price) }
    it { should validate_presence_of(:books_in_stock) }
    it { should validate_presence_of(:short_description) }
    it { should validate_length_of(:short_description) }
    it { should validate_presence_of(:description) }
  end

  describe "default scope" do
    it "returns books in descending order" do
      book1 = create :book
      book2 = create :book
      expect(Book.all).to match_array [book2, book1, subject]
    end
  end

  describe "#rating" do
    it "returns 0 if no ratings" do
      expect(subject.rating).to be_zero
    end

    it "returns 5 if one rating with number eq to 5" do
      rating = create :rating, book: subject, number: 5, state: "approved"
      expect(subject.rating).to eq 5
    end

    it "returns 5 if two ratings with numbers eq to 5" do
      rating1 = create :rating, book: subject, number: 5, state: "approved"
      rating2 = create :rating, book: subject, number: 5, state: "approved"
      expect(subject.rating).to eq 5
    end

    it "returns 4 if two ratings with number 3 and 5" do
      rating1 = create :rating, book: subject, number: 3, state: "approved"
      rating2 = create :rating, book: subject, number: 5, state: "approved"
      expect(subject.rating).to eq 4
    end

    it "returns 0 if one rating with number eq to 5 but state is pending" do
      rating1 = create :rating, book: subject, number: 5
      expect(subject.rating).to be_zero
    end
  end

  describe "#search" do
    it "returns all books when no query" do
      books = Book.search(nil)
      expect(books).to eq Book.all
    end

    it "returns correct result when search by title" do
      book = Book.search(subject.title).first
      expect(book).to eq book
    end

    it "returns correct result when search by author first name" do
      founded = Book.search(subject.author.first_name)
      expect(founded.first).to eq subject
    end

    it "returns correct result when search by author last name" do
      founded = Book.search(subject.author.last_name)
      expect(founded.first).to eq subject
    end
  end

  describe "#to_s" do
    it "returns a title" do
      expect(subject.to_s).to eq subject.title
    end
  end

  describe "#best_sellers" do
    before do
      10.times { create :book }
    end

    it "returns empty when no order items" do
      expect(Book.best_sellers).to be_empty
    end

    it "returns correct book when one order item exists" do
      item = create :order_item
      expect(Book.best_sellers).to match_array(item.book)
    end

    it "returns two books" do
      item1 = create :order_item
      item2 = create :order_item
      expect(Book.best_sellers).to match_array([item1.book, item2.book])
    end

    it "returns books in correct order dependent of quantity in order items" do
      item1 = create :order_item, quantity: 3
      item2 = create :order_item, quantity: 5
      item3 = create :order_item, quantity: 2
      expect(Book.best_sellers).to eq [item2.book, item1.book, item3.book]
    end
  end
end
