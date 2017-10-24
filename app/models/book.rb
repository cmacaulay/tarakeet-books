class Book < ApplicationRecord
  validates_presence_of :title
  has_many   :book_reviews
  belongs_to :publisher
  belongs_to :author
end
