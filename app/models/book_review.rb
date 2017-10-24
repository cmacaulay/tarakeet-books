class BookReview < ApplicationRecord
  validates_presence_of :rating
  validates :rating, :inclusion => { :in => 1..5 }
  belongs_to :book
end
