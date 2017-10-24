class BookFormatType < ApplicationRecord
  validates_presence_of :name
  has_many :books, through: :book_formats
end
