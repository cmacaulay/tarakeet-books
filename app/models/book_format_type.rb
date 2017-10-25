class BookFormatType < ApplicationRecord
  validates_presence_of :name

  has_many :book_formats
  has_many :books, through: :book_formats

  scope :format, -> (id) { where id: id }
  scope :physical, -> { where physical: true}
end
