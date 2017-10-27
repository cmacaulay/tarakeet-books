FactoryBot.define do
  factory :book_format_type do
    sequence(:name) { |n| "Book Type #{n}" }
    physical false
  end
end
