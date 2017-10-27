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

      it "returns query defined results when no options are given" do
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
        digital   = create(:book_format_type, name: "Word Doc", physical: false)
        physical  = create(:book_format_type, name: "Coffee Table", physical: true)
        book      = create(:book_with_book_reviews, title: "The Book of Art")
        create(:book_format, book_format_type: physical, book: book)
        create_list(:book_format, 5, book_format_type: digital)

        result = Book.search("Art", book_format_physical: true)

        expect(result.length).to eq(1)
        expect(result.first.title).to eq(book.title)
      end

      it "allows you to query and apply the :book_format_type_id option" do
        type_id   = create(:book_format_type).id
        best_book = create(:book, title: "War and Peace")
        create(:book_review, book: best_book, rating: 5)
        create(:book_format, book_format_type_id: type_id, book: best_book)
        3.times { create(:book_format, book_format_type_id: type_id, book: create(:book_with_book_reviews))}

        result = Book.search("peace", book_format_type_id: type_id)

        expect(result.length).to eq(1)
        expect(result.first).to eq(best_book)
      end

      it "allows you to query and appy both the :title_only and :book_format_physical options" do
        physical_id = create(:book_format_type, name: "Paperback", physical: true).id
        best_book   = create(:book, title: "To Kill A Mockingbird")
        create(:book_format, book_format_type_id: physical_id, book: best_book)
        create(:book_review, book: best_book, rating: 5)
        8.times { create(:book_format, book_format_type_id: physical_id, book: create(:book_with_book_reviews)) }

        result = Book.search("Mockingbird", title_only: true, book_format_physical: true)

        expect(result.length).to eq(1)
        expect(result.class).to eq(Array)
        expect(result.first).to eq(best_book.title)
      end

      it "allows you to query and both :title_only and :book_format_type_id" do
        type_id = create(:book_format_type, name: "Paperback", physical: true).id
        best_book   = create(:book, title: "Catch 22")
        create(:book_format, book_format_type_id: type_id, book: best_book)
        create(:book_review, book: best_book, rating: 5)
        5.times { create(:book_format, book_format_type_id: type_id, book: create(:book_with_book_reviews)) }

        result = Book.search("22", title_only: true, book_format_type_id: type_id)

        expect(result.length).to eq(1)
        expect(result.first).to eq(best_book.title)
      end

      # what happens if you search for something that does not exist?
      
    end
