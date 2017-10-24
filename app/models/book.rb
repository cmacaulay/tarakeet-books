class Book < ApplicationRecord
  validates_presence_of :title
  has_many   :book_reviews
  has_many   :book_format_types, through: :book_formats
  belongs_to :publisher
  belongs_to :author

  def author_name
    "#{author.last_name}, #{author.first_name}"
  end
end
