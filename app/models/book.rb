class Book < ApplicationRecord
  validates_presence_of :title

  has_many   :book_reviews
  has_many   :book_formats
  has_many   :book_format_types, through: :book_formats

  belongs_to :publisher
  belongs_to :author

  def author_name
    author.format_name
  end

  def average_rating
    (book_reviews.sum(:rating).to_f / book_reviews.count).round(1)
  end

  def books_by_rating

  end

  def self.search(query, options)
    self.joins(:book_reviews)
    .group('books.id')
    .order('AVG(book_reviews.rating) DESC')
  end

end
