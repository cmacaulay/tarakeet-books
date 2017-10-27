class Book < ApplicationRecord
  validates_presence_of :title

  has_many   :book_reviews
  has_many   :book_formats
  has_many   :book_format_types, through: :book_formats

  belongs_to :publisher
  belongs_to :author

  scope :title_only, -> { pluck(:title) }

  def author_name
    author.format_name
  end

  def average_rating
    (book_reviews.sum(:rating).to_f / book_reviews.count).round(1)
  end

  def self.search(query, options)
    return books_by_rating if !query && !options

    if !options
      query_lookup(query)
    elsif options.length == 2
      two_options_search_filter(query, options)
    else
      single_option_search_filter(query, options)
    end
  end

  def self.single_option_search_filter(query, options)
    if options[:title_only]
      !query ? books_by_rating.title_only : query_lookup(query).title_only
    elsif options[:book_format_type_id]
      id = options[:book_format_type_id]
      !query ? book_format_type(id) : query_lookup(query).book_format_type(id)
    elsif options[:book_format_physical] == true
      !query ? book_format_physical : query_lookup(query).book_format_physical
    end
  end

  def self.two_options_search_filter(query, options)
    if !options[:book_format_type_id]
      book_format_physical.title_only if !query
    elsif !options[:book_format_physical]
      id = options[:book_format_type_id]
      book_format_type(id).title_only if !query
    end
  end

  private
  def self.query_lookup(query)
    search_by_title(query).length > 0 ? search_by_title(query) : search_by_author_name(query)
  end

  def self.search_by_title(query)
    books_by_rating.where("title LIKE ? ", "%#{query}%")
  end

  def self.search_by_author_name(query)
    books_by_rating.joins(:author).where("authors.first_name = ? OR authors.last_name = ?" , query, query)
  end

  def self.books_by_rating
    select('DISTINCT books.*, AVG(book_reviews.rating)')
    .joins(:book_reviews)
    .group('books.id')
    .order('AVG(book_reviews.rating) DESC')
  end

  def self.book_format_type(id)
    select('DISTINCT books.*, AVG(book_reviews.rating)')
    .joins(:book_format_types, :book_reviews)
    .merge(BookFormatType.format(id))
    .group('books.id')
    .order('AVG(book_reviews.rating) DESC')
  end

  def self.book_format_physical
    select('DISTINCT books.*, AVG(book_reviews.rating)')
    .joins(:book_format_types, :book_reviews)
    .merge(BookFormatType.physical)
    .group('books.id')
    .order('AVG(book_reviews.rating) DESC')
  end

end
