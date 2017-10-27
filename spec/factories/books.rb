FactoryBot.define do
  factory :book do
    sequence(:title) { |n| "Harry Potter: #{n}" }
    publisher
    author

    factory :book_with_book_reviews do
      transient do
        book_reviews_count 5
      end

      after(:create) do |book, evaluator|
        create_list(:book_review, evaluator.book_reviews_count, book: book)
      end
    end
  end
end
