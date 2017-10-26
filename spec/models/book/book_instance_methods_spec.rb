require 'rails_helper'

describe "#author_name" do
  it "does not return the first name first" do
    author = FactoryBot.create(:author,
                              first_name: "Malcom",
                              last_name:  "Gladwell")
    book   = FactoryBot.create(:book,
                               title: "Blink",
                               author: author)

    result = book.author_name

    expect(result).to_not eq("Malcom, Gladwell")
  end

  it "returns the author's name in the correct format" do
    author = FactoryBot.create(:author,
                              first_name: "Malcom",
                              last_name:  "Gladwell")
    book   = FactoryBot.create(:book,
                               title: "Blink",
                               author: author)

    result = book.author_name

    expect(result).to eq("Gladwell, Malcom")
  end
end

describe "#book_format_types" do
  it "returns a collection of BookFormatTypes for single book" do
    book  = create(:book)
    create(:book_format,
           book: book,
           book_format_type: create(:book_format_type,
                                    name: "Hardcover",
                                    physical: true))
    create(:book_format,
           book: book,
           book_format_type: create(:book_format_type,
                                    name: "PDF"))

    result = book.book_format_types

    expect(result.count).to eq(2)
    expect(result.first.name).to eq("Hardcover")
    expect(result.last.name).to eq("PDF")
  end
end

describe "#average_rating" do
  it "returns the mean average of all reviews for a single book" do
    book = create(:book)
    create_list(:book_review, 3, book: book, rating: 2)
    create_list(:book_review, 4, book: book, rating: 5)

    result = book.average_rating

    expect(book.book_reviews.count).to eq(7)
    expect(result).to eq(3.7)
  end
end
