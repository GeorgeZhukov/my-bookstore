require 'rails_helper'

RSpec.describe Book, type: :model do
  subject { FactoryGirl.create :book }

  it { expect(subject).to validate_presence_of(:title) }
  it { expect(subject).to validate_presence_of(:price) }
  it { expect(subject).to validate_presence_of(:books_in_stock) }
  it { expect(subject).to validate_presence_of(:short_description) }
  it { expect(subject).to validate_length_of(:short_description) }
  # it { expect(subject).to validate_presence_of(:description) }
  # it { expect(subject).to validate_presence_of(:cover) }

  it { expect(subject).to belong_to :author }
  it { expect(subject).to belong_to :category }
  it { expect(subject).to have_many :ratings }

  describe "default scope" do
    it "returns books in descending order" do
      Book.destroy_all
      book1 = FactoryGirl.create :book
      book2 = FactoryGirl.create :book
      expect(Book.all.to_a).to eq [book2, book1]
    end
  end

  describe ".search" do
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

  describe ".to_s" do
    it "returns a title" do
      expect(subject.to_s).to eq subject.title
    end
  end

  describe ".best_sellers" do
    before do
      10.times { FactoryGirl.create :book }
    end

    it "returns empty when no order items" do
      expect(Book.best_sellers).to be_empty
    end

    it "returns correct book when one order item exists" do
      item = FactoryGirl.create :order_item
      expect(Book.best_sellers).to match_array(item.book)
    end

    it "returns two books" do
      item1 = FactoryGirl.create :order_item
      item2 = FactoryGirl.create :order_item
      expect(Book.best_sellers).to match_array([item1.book, item2.book])
    end

    it "returns books in correct order dependent of quantity in order items" do
      item1 = FactoryGirl.create :order_item, quantity: 3
      item2 = FactoryGirl.create :order_item, quantity: 5
      item3 = FactoryGirl.create :order_item, quantity: 2
      expect(Book.best_sellers).to eq [item2.book, item1.book, item3.book]
    end
  end
end
