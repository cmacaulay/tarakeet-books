require 'rails_helper'

RSpec.describe Book, type: :model do
  context "validations" do
    it { should validate_presence_of(:title) }
  end

  context "relationships" do
    it { should belong_to(:publisher) }
    it { should belong_to(:author) }
    it { should have_many(:book_reviews) }
    # it { should have_many(:book_format_types).through(:book_formats) }
  end

  it "has a valid factory" do
    book = FactoryBot.create(:book)
    expect(book).to be_valid
  end

  it "is not valid without a title" do
    book = Book.new(title: "Born A Crime")
    expect(book).to_not be_valid
  end

  it "is not valid without a publisher id" do
    author_id = Author.create(first_name: "Trevor", last_name: "Noah").id
    book = Book.new(title: "Born A Crime", author_id: author_id)

    expect(book).to_not be_valid
  end

  it "is not valid without a author id" do
    publisher_id = FactoryBot.create(:publisher).id
    book = Book.new(title: "Born A Crime", publisher_id: publisher_id)

    expect(book).to_not be_valid
  end

  it "is valid with all fields" do
    pub_id = Publisher.create(name: "Harper Collins").id
    auth_id = Author.create(first_name: "Trevor", last_name: "Noah").id
    book = Book.new(title: "Born A Crime",
                    publisher_id: pub_id,
                    author_id: auth_id)
    expect(book).to be_valid
  end

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

end
