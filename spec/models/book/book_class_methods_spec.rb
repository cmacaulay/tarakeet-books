require 'rails_helper'

  describe "#self.search" do
    it "returns all books in order when there's no query" do
      pub_id = create(:publisher).id
      book1  = create(:book, publisher_id: pub_id)
      book2  = create(:book, title: "Lolita", publisher_id: pub_id)
      create_list(:book_review, 2, book: book1, rating: 5)
      create_list(:book_review, 4, book: book2, rating: 3)

      result = Book.search(nil, nil)

      expect(result.first).to eq(book1)
      expect(result.last).to eq(book2)
    end

    context "search options" do

      it "returns all book titles when no query is given with :title_only option " do
        pub_id = create(:publisher).id
        book1  = create(:book, publisher_id: pub_id)
        book2  = create(:book, title: "Lolita", publisher_id: pub_id)
        create_list(:book_review, 2, book: book1, rating: 3)
        create_list(:book_review, 4, book: book2, rating: 5)

        result = Book.search(nil, title_only: true)

        expect(result.class).to eq(Array)
        expect(result.count).to eq(2)
        expect(result).to eq(["#{book2.title}", "#{book1.title}"])
      end

      it "returns only books available in format when :book_format_type_id is given" do
        create(:book_format_type, id: 1, name: "Hardcover", physical: true)
        create(:book_format_type, id: 2, name: "Kindle Book", physical: false)

        book = create(:book, title: "Blink")
        create(:book_review, book: book, rating: 5)
        create(:book_format, book_format_type_id: 2, book: book)

        6.times { create(:book_format, book_format_type_id: 2, book: create(:book_with_book_reviews)) }
        5.times { create(:book_format, book_format_type_id: 1, book: create(:book_with_book_reviews)) }

        result = Book.search(nil, book_format_type_id: 2)

        expect(result.length).to eq(7)
        expect(result.first.title).to eq(book.title)
      end

      it "returns all book records with physical formats when :book_format_physical is given" do
        physical = create(:book_format_type, name: "Paperback", physical: true)
        digital  = create(:book_format_type, name: "E-Book", physical: false)

        3.times { create(:book_format, book_format_type: physical, book: create(:book_with_book_reviews)) }
        5.times { create(:book_format, book_format_type: digital, book: create(:book_with_book_reviews)) }

        result = Book.search(nil, book_format_physical: true)

        expect(result.length).to eq(3)
      end

      it "accepts both :title_only and book_format_physical as options" do
        physical_id = create(:book_format_type, name: "Paperback", physical: true).id
        best_book   = create(:book, title: "To Kill A Mockingbird")
        create(:book_format, book_format_type_id: physical_id, book: best_book)
        create(:book_review, book: best_book, rating: 5)
        8.times { create(:book_format, book_format_type_id: physical_id, book: create(:book_with_book_reviews)) }

        result = Book.search(nil, title_only: true, book_format_physical: true)

        expect(result.length).to eq(9)
        expect(result.first).to eq(best_book.title)
      end

      it "accepts both :title_only and book_format_type_id as options" do
        physical_id = create(:book_format_type, name: "Paperback", physical: true).id
        best_book   = create(:book, title: "Catch 22")
        create(:book_format, book_format_type_id: physical_id, book: best_book)
        create(:book_review, book: best_book, rating: 5)
        5.times { create(:book_format, book_format_type_id: physical_id, book: create(:book_with_book_reviews)) }

        result = Book.search(nil, title_only: true, book_format_type_id: physical_id)

        expect(result.length).to eq(6)
        expect(result.first).to eq(best_book.title)
      end
    end

    context "search query" do

    end
  end
