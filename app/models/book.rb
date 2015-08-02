class Book < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :author
  belongs_to :category
  has_many :ratings

  validates :title, presence: true
  validates :price, presence: true
  validates :books_in_stock, presence: true
  validates :short_description, presence: true
  validates :description, presence: true

  mount_uploader :cover, BookCoverUploader

  def self.search(query)
    return all unless query

    if Rails.configuration.database_configuration[Rails.env]["adapter"] == "sqlite3"
      query.downcase!
      joins(:author).where("lower(books.title) LIKE ? OR lower(authors.first_name || ' ' || authors.last_name) LIKE ?", "%#{query}%", "%#{query}%")
    else
      joins(:author).where("books.title ILIKE ? OR CONCAT(authors.first_name,' ',authors.last_name) ILIKE ?", "%#{query}%", "%#{query}%")
    end
  end

  def self.best_sellers
    # Group order items by book and return
    # an array of books
    OrderItem.group(:book, :quantity).order(quantity: :desc).count.map { |item| item.first }
  end
end
