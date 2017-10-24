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
    (book_reviews.pluck(:rating).inject(:+).to_f / book_reviews.count).round(1)
  end
end
