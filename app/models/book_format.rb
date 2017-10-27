class BookFormat < ApplicationRecord
  validates_presence_of :book_id,
                        :book_format_type_id

  belongs_to :book
  belongs_to :book_format_type
end
