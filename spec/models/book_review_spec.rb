require 'rails_helper'

RSpec.describe BookReview, type: :model do
  context "validations" do
    it { should validate_presence_of(:rating) }
    it { should validate_inclusion_of(:rating).in_range(1..5) }
  end

  context "relationships" do
    it { should belong_to(:book) }
  end

  it "has a valid factory" do
    review = FactoryBot.create(:book_review)

    expect(review).to be_valid
  end

  it "is not valid without a book" do
    review  = BookReview.new(rating: 5)

    expect(review).to_not be_valid
  end

  it "is not valid with a rating of nil" do
    book   = FactoryBot.create(:book)
    review = BookReview.new(book: book,
                            rating: nil)

    expect(review).to_not be_valid
  end

  it "is not valid with a rating greater than 5" do
    book   = FactoryBot.create(:book)
    review = BookReview.new(book: book,
                            rating: 5000)

    expect(review).to_not be_valid
  end

  it "is valid with a book and a rating between 1-5" do
    book   = FactoryBot.create(:book)
    review = BookReview.new(book: book,
                            rating: 5)

    expect(review).to be_valid
  end

end
