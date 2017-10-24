require 'rails_helper'

RSpec.describe BookFormat, type: :model do
  context "validations" do
    it { should validate_presence_of(:book_id) }
    it { should validate_presence_of(:book_format_type_id) }
  end

  context "validations" do
    it { should belong_to(:book) }
    it { should belong_to(:book_format_type) }
  end

  it "has a valid factory" do
    book_format = FactoryBot.create(:book_format)

    expect(book_format).to be_valid
  end

  it "is not valid without a format type" do
    book = FactoryBot.create(:book)
    book_format = BookFormat.new(book: book)

    expect(book_format).to_not be_valid
  end

  it "is not valid without a book" do
    type = FactoryBot.create(:book_format_type)
    book_format = BookFormat.new(book_format_type: type)

    expect(book_format).to_not be_valid
  end

  it "is valid with all fields" do
    type = FactoryBot.create(:book_format_type)
    book = FactoryBot.create(:book)
    book_format = BookFormat.new(book: book,
                                 book_format_type: type)

    expect(book_format).to be_valid
  end
end
