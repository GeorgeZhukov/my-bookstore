require 'rails_helper'

RSpec.describe Book, type: :model do
  it { expect(subject).to validate_presence_of(:title) }
  it { expect(subject).to validate_presence_of(:price) }
  it { expect(subject).to validate_presence_of(:books_in_stock) }
  it { expect(subject).to validate_presence_of(:short_description) }
  it { expect(subject).to validate_length_of(:short_description) }
  it { expect(subject).to belong_to :author }
  it { expect(subject).to belong_to :category }
  it { expect(subject).to have_many :ratings }

  describe ".search" do
    subject { FactoryGirl.create :book }
    it "returns all books when no query" do
      books = Book.search(nil)
      expect(books).to eq Book.all
    end

    it "returns correct result when search by title" do
      book = Book.search(subject.title).first
      expect(book).to eq book
    end

    it "returns correct result when search by author" do
      founded = Book.search(subject.author.first_name)
      expect(founded.first).to eq subject
    end

    it "returns correct result when search by author" do
      founded = Book.search(subject.author.last_name)
      expect(founded.first).to eq subject
    end
  end
end
