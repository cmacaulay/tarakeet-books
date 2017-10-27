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
      it "returns results of case insensitive queries when no options are given" do
        author = create(:author, first_name: "J.K", last_name: "Rowling")
        best_book = create(:book, author: author, title: "Fantastic Beasts & Where to Find Them")
        create(:book_review, rating: 5, book: best_book)
        create_list(:book_with_book_reviews, 7, author: author)

        query_first = Book.search("j.k", nil)
        query_last  = Book.search("ROWLING", nil)
        query_title = Book.search("Fantastic", nil)

        expect(query_first.length).to eq(8)
        expect(query_last.length).to eq(8)
        expect(query_title.length).to eq(1)
        expect(query_last.first).to eq(query_first.first)
      end

      it "allows you to search using a query and the :title_only option" do
        author    = create(:author, first_name: "Ralph", last_name: "Ellison")
        best_book = create(:book, author: author, title: "Invisible Man")
        create(:book_review, book: best_book, rating: 5)
        create_list(:book_with_book_reviews, 4, author: author)
        create_list(:book_with_book_reviews, 3)

        result      = Book.search("ralph", title_only: true)
        best_result = Book.search("Man", title_only: true)

        expect(result.length).to eq(5)
        expect(result.class).to eq(Array)
        expect(result.first).to eq(best_book.title)

        expect(best_result.length).to eq(1)
        expect(best_result.first).to eq(best_book.title)
      end

      it "allows you to query and apply the :book_format_physical option" do

      end

      # it "allows you to query and apply the :book_format_type_id option"
      # it "allows you to query and both :title_only and :book_format_physical" do
      # it "allows you to query and both :title_only and :book_format_type_id" do

    end
  end
