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

  def self.search(query, options)
    return books_by_rating if !query && !options
    if options[:title_only]
      if !query
        books_by_rating.pluck(:title)
      end
    elsif options[:book_format_type_id]
      if !query
        self.book_format_type(options[:book_format_type_id])
      end
    elsif options[:book_format_physical] == true
      if !query
        self.book_format_physical
      end
    end
  end

  private

  def self.books_by_rating
    self.joins(:book_reviews)
    .group('books.id')
    .order('AVG(book_reviews.rating) DESC')
  end

  def self.book_format_type(id)
    select('DISTINCT books.title, AVG(book_reviews.rating)')
    .joins(:book_format_types, :book_reviews)
    .merge(BookFormatType.format(id))
    .group('books.id')
    .order('AVG(book_reviews.rating) DESC')
  end

  def self.book_format_physical
    select('DISTINCT books.title, AVG(book_reviews.rating)')
    .joins(:book_format_types, :book_reviews)
    .merge(BookFormatType.physical)
    .group('books.id')
    .order('AVG(book_reviews.rating) DESC')
  end

end
