class Author < ApplicationRecord
  validates_presence_of :first_name,
                        :last_name

  has_many :books

  def format_name
    "#{last_name}, #{first_name}"
  end

  def self.search_by_first_name(query)
    select('authors.first_name AS first_name')
    .where('first_name LIKE #{query}')
  end

  def self.search_by_last_name
  end
end
