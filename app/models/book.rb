class Book < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :author
  belongs_to :category
  has_many :ratings

  validates :title, presence: true
  validates :price, presence: true
  validates :books_in_stock, presence: true, numericality: {greater_than_or_equal_to: 1}
  validates :short_description, presence: true
  validates :description, presence: true
  validates :cover, presence: true

  mount_uploader :cover, BookCoverUploader

  delegate :approved, to: :ratings, prefix: true

  default_scope { order(created_at: :desc) }

  rails_admin do
    list do
      configure :description do
        hide
      end
    end
    edit do
      configure :ratings do
        hide
      end
      configure :description, :wysihtml5 do
        config_options toolbar: { fa: true, image: false, link: false }, # use font-awesome instead of glyphicon
                       html: true, # enables html editor
                       parserRules: { tags: { p:1 } } # support for <p> in html mode
      end
    end
  end

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
    OrderItem.group(:book).order("sum(quantity) DESC").count.map { |item| item.first }
  end

  def to_s
    title
  end

  def avg_rating
    return 0 unless ratings_approved.exists?
    numbers = ratings_approved.map(&:number)
    numbers.inject(&:+).to_f / numbers.size
  end
end
